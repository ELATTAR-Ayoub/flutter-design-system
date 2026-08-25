// Wheel-stitch capture: loads a page at 1440x900, screenshots, wheels down in
// ~810px steps, verifies the actual advance by correlating the frame overlap,
// and stitches the run into one tall PNG. Works identically for the DOM app
// and the Flutter canvas app (no DOM scroll reads — the pixels are the truth).
//
// usage: node capture.js <url> <out.png> [--theme dark|light] [--settle ms]
//        [--nav networkidle2|domcontentloaded] [--reduced] [--clock ...]
//
// --nav domcontentloaded is for pages that never go network-idle. The
// documentation error states are the ones that matter: they render ElAlert,
// whose ElBloomCosmic controllers repeat forever, and the page keeps the
// connection busy for as long as it is open. networkidle2 simply never
// fires there and the capture dies on the 90s navigation timeout. This is
// the browser-side twin of the rule the widget tests already follow: on any
// page containing ElAlert, pump, never pumpAndSettle.
const fs = require('fs');
const puppeteer = require('puppeteer-core');
const { PNG } = require('pngjs');

const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const VIEW_W = 1440;
const VIEW_H = 900;
const STEP = 810;
const MAX_STEPS = 40;

function parseArgs() {
  const [url, out] = process.argv.slice(2);
  const args = { url, out, theme: null, settle: 1200, reduced: false, clock: null, nav: 'networkidle2' };
  for (let i = 4; i < process.argv.length; i++) {
    if (process.argv[i] === '--theme') args.theme = process.argv[++i];
    if (process.argv[i] === '--settle') args.settle = +process.argv[++i];
    if (process.argv[i] === '--reduced') args.reduced = true;
    if (process.argv[i] === '--clock') args.clock = process.argv[++i];
    if (process.argv[i] === '--nav') args.nav = process.argv[++i];
  }
  return args;
}

// The shell is static while only the content column scrolls, so frame
// matching must ignore the rail (left 240 + border), the sticky header
// (top 64) and the scrollbar (right edge) — static pixels make every offset
// look alike and let the matcher lock onto garbage.
const CLIP_X0 = 248;
const CLIP_X1 = 1424;
const CLIP_Y0 = 64;

// Per-row luminance signature over the content clip, every 8th pixel.
function rowSignature(png) {
  const sig = new Float64Array(png.height);
  for (let y = 0; y < png.height; y++) {
    let acc = 0;
    for (let x = CLIP_X0; x < CLIP_X1; x += 8) {
      const i = (y * png.width + x) * 4;
      acc += png.data[i] + png.data[i + 1] + png.data[i + 2];
    }
    sig[y] = acc;
  }
  return sig;
}

// Did the frame move at all? Ask the content pixels at offset zero BEFORE
// trusting any step match: identical content means the bottom clamp (none of
// these pages shows a full viewport of blank mid-scroll, so identical ⇒
// stopped). This is the order the v2 matcher got wrong — it asked "does a
// step-sized advance fit" first, and a blank tail answers yes forever. A
// scrollbar-thumb oracle fails the other way: headless Chrome auto-hides the
// web page's overlay scrollbar while Flutter always paints its own.
function frameMoved(prevSig, newSig) {
  let sad = 0;
  let count = 0;
  for (let y = CLIP_Y0; y < prevSig.length; y += 1) {
    sad += Math.abs(prevSig[y] - newSig[y]);
    count++;
  }
  return sad / count > 40;
}

function sadAt(prevSig, newSig, o) {
  const H = prevSig.length;
  const n = H - o;
  let sad = 0;
  let count = 0;
  for (let r = CLIP_Y0; r < n; r += 2) {
    sad += Math.abs(prevSig[o + r] - newSig[r]);
    count++;
  }
  return count > 0 ? sad / count : Infinity;
}

// Find the advance o such that prev rows [o..H) match new rows [0..H-o).
//
// Browsers apply wheel deltas to an instant page exactly, so the true
// advance IS the step until the bottom clamp. Self-similar content (the
// typography page's repeating spec rows) produces near-tied matches at
// 810±24 — so the burden of proof is inverted: STEP wins unless another
// offset is decisively better (3× cleaner AND past an absolute floor),
// which only the genuine bottom-clamp partial advance ever is.
function findAdvance(prevSig, newSig) {
  const H = prevSig.length;
  const sadStep = sadAt(prevSig, newSig, STEP);
  let best = { o: 0, sad: Infinity };
  for (let o = 0; o <= H - 60; o++) {
    const sad = sadAt(prevSig, newSig, o);
    if (
      sad < best.sad - 1e-9 ||
      (Math.abs(sad - best.sad) < 1e-9 &&
        Math.abs(o - STEP) < Math.abs(best.o - STEP))
    ) {
      best = { o, sad };
    }
  }
  // STEP wins ties against self-similar content, but never against an
  // exact match elsewhere: at the bottom clamp the true (smaller) advance
  // overlaps pixel-identically (sad ≈ 0), and an absolute leniency floor
  // here let a plausible 810 override it and over-append the tail.
  if (sadStep <= Math.max(best.sad * 3, 50)) {
    return { o: STEP, sad: sadStep, mode: 'step' };
  }
  return { ...best, mode: 'scan' };
}

(async () => {
  const { url, out, theme, settle, reduced, clock, nav } = parseArgs();
  const browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: true,
    args: [
      `--window-size=${VIEW_W},${VIEW_H + 120}`,
      '--force-color-profile=srgb',
      '--force-device-scale-factor=1',
      '--disable-lcd-text', // grayscale AA on the DOM side too, like the canvas
    ],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({
      width: VIEW_W,
      height: VIEW_H,
      deviceScaleFactor: 1,
    });
    if (reduced) {
      // Freezes loopers to their contractual reduced state — on the WEB app
      // only: the CSS blanket rule reads this media feature, but CDP media
      // emulation never reaches the Flutter engine's accessibility channel
      // (proven: identical captures with/without). The Flutter app freezes
      // via its own `?motion=reduced` boot param instead; passing --reduced
      // to a Flutter capture is harmless and kept for symmetric invocation.
      // Unsynced infinite phases would otherwise paint noise the comparison
      // cannot attribute.
      await page.emulateMediaFeatures([
        { name: 'prefers-reduced-motion', value: 'reduce' },
      ]);
    }
    if (clock) {
      // Calendar pages are date-dependent (row counts move the document
      // ±36px per calendar with the month). Freeze the DOM app's clock to
      // the same instant the Flutter app gets via its ?clock= boot param.
      await page.evaluateOnNewDocument((fixedIso) => {
        const OrigDate = Date;
        const fixed = new OrigDate(fixedIso).getTime();
        const offset = fixed - OrigDate.now();
        const now = () => OrigDate.now() + offset;
        const Shim = new Proxy(OrigDate, {
          construct(t, args) {
            return args.length ? new t(...args) : new t(now());
          },
          apply() {
            return new OrigDate(now()).toString();
          },
          get(t, k) {
            return k === 'now' ? now : t[k];
          },
        });
        window.Date = Shim;
      }, clock);
    }
    if (theme) {
      // next-themes reads localStorage('theme'); the Flutter app takes ?theme=
      // in its URL instead, so this is harmless there.
      await page.evaluateOnNewDocument((t) => {
        try {
          localStorage.setItem('theme', t);
        } catch (_) {}
      }, theme);
    }
    // The Next dev-overlay badge is chrome, not the page.
    await page.evaluateOnNewDocument(() => {
      const hide = () => {
        const s = document.createElement('style');
        s.textContent = 'nextjs-portal{display:none!important}';
        document.documentElement.appendChild(s);
      };
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', hide);
      } else {
        hide();
      }
    });

    await page.goto(url, { waitUntil: nav, timeout: 90000 });
    try {
      await page.evaluate(() => document.fonts && document.fonts.ready);
    } catch (_) {}
    await new Promise((r) => setTimeout(r, settle));
    // Startup settle: CanvasKit loads its fonts outside document.fonts, and a
    // capture that starts before the swap measures fallback metrics — worth
    // ~570px of phantom height on a text-heavy page. Poll until two
    // consecutive shots are pixel-stable before frame 0 counts.
    {
      let prev = rowSignature(PNG.sync.read(await page.screenshot()));
      for (let i = 0; i < 40; i++) {
        await new Promise((r) => setTimeout(r, 500));
        const cur = rowSignature(PNG.sync.read(await page.screenshot()));
        const stable = !frameMoved(prev, cur);
        prev = cur;
        if (stable) break;
      }
    }

    // The cursor has two jobs that need two positions: wheel events must hit
    // the main scrollable (content column), but a cursor RESTING on content
    // hovers whatever scrolls under it — Flutter re-hit-tests on scroll, so
    // every frame lights a different tile and frames stop being translations
    // of each other. Wheel over content, then park in dead header padding
    // before every screenshot.
    const WHEEL_AT = [VIEW_W * 0.55, VIEW_H * 0.6];
    const PARK_AT = [8, 8];
    await page.mouse.move(...PARK_AT);

    // An autofocusing element (cmdk's palette input on the selects page)
    // makes the browser scroll it into view BEFORE frame 0, so the stitch
    // silently starts mid-page and the total comes out short by the initial
    // scroll offset. Blur whatever holds focus and pin the scroll back to
    // the top before the first frame counts.
    await page.evaluate(() => {
      if (document.activeElement && document.activeElement.blur) {
        document.activeElement.blur();
      }
      window.scrollTo({ top: 0, behavior: 'instant' });
    });
    try {
      await page.evaluate(
        () => window.__elScrollTo && window.__elScrollTo(0),
      );
    } catch (_) {}
    await new Promise((r) => setTimeout(r, 400));

    // The DOM app scrolls deterministically — no matching, no ambiguity. The
    // Flutter app exposes the same ground truth through a js_interop seam
    // (__elScrollTo/__elScrollY/__elScrollMax): pixel matching cannot recover
    // even the final clamped advance, because the viewport-fixed page glow
    // makes no two scroll positions pure translations of each other. The
    // wheel path below survives only as a fallback for bundles without the
    // seam — its totals over-append at the bottom clamp and must not be
    // trusted for height verdicts.
    const domScroll = url.includes('localhost:3000');
    const probeScroll =
      !domScroll &&
      (await page
        .evaluate(
          () =>
            typeof window.__elScrollTo === 'function' &&
            typeof window.__elScrollY === 'function',
        )
        .catch(() => false));

    const frames = [];
    let png = PNG.sync.read(await page.screenshot());
    let sig = rowSignature(png);
    frames.push({ png, take: VIEW_H }); // frame 0 contributes fully
    const advances = [];

    for (let step = 0; step < MAX_STEPS; step++) {
      let advance;
      let sad = 0;
      let mode;
      if (domScroll || probeScroll) {
        const read = () =>
          domScroll
            ? page.evaluate(() => window.scrollY)
            : page.evaluate(() => window.__elScrollY());
        const before = await read();
        if (domScroll) {
          await page.evaluate(
            (y) => window.scrollTo({ top: y, behavior: 'instant' }),
            before + STEP,
          );
        } else {
          await page.evaluate((y) => window.__elScrollTo(y), before + STEP);
        }
        await new Promise((r) => setTimeout(r, 350));
        const after = await read();
        // The only rounding in the pipeline: Flutter's maxScrollExtent can be
        // fractional, so the final clamped advance may round by ≤0.5px. Every
        // other advance is the integral STEP echoed back exactly.
        advance = Math.round(after - before);
        mode = domScroll ? 'dom' : 'probe';
        if (advance < 4) break;
        const next = PNG.sync.read(await page.screenshot());
        sig = rowSignature(next);
        advances.push({ advance, mode });
        frames.push({ png: next, take: advance });
        png = next;
        continue;
      }
      await page.mouse.move(...WHEEL_AT);
      await page.mouse.wheel({ deltaY: STEP });
      await page.mouse.move(...PARK_AT);
      // Poll until the frame SETTLES (two consecutive identical shots) —
      // Flutter web can animate wheel scrolls.
      let next = PNG.sync.read(await page.screenshot());
      let nextSig = rowSignature(next);
      for (let settle = 0; settle < 12; settle++) {
        await new Promise((r) => setTimeout(r, 250));
        const probe = PNG.sync.read(await page.screenshot());
        const probeSig = rowSignature(probe);
        const settled = !frameMoved(nextSig, probeSig);
        next = probe;
        nextSig = probeSig;
        if (settled) break;
      }
      if (!frameMoved(sig, nextSig)) {
        // Bottom clamp: the LAST appended frame advanced less than a full
        // step. Rescan it now — this is the only frame whose advance is not
        // the wheel's own 810, so it is the only matcher decision left.
        if (frames.length > 1) {
          const prevFrame = frames[frames.length - 2].png;
          const lastFrame = frames[frames.length - 1].png;
          const { o, sad: clampSad } = findAdvance(
            rowSignature(prevFrame),
            rowSignature(lastFrame),
          );
          advances[advances.length - 1] = {
            advance: o,
            sad: +clampSad.toFixed(1),
            mode: 'clamp-rescan',
          };
          frames[frames.length - 1].take = o;
        }
        break;
      }
      // The wheel scrolls exactly STEP — the page glow is viewport-fixed, so
      // scrolled content is never a pure translation and any matcher given
      // freedom here will eventually prefer a glow-flattering wrong offset.
      // Telemetry only:
      ({ o: advance, sad, mode } = findAdvance(sig, nextSig));
      advances.push({
        advance: STEP,
        sad: +sad.toFixed(1),
        mode: `wheel(scan said ${advance}/${mode})`,
      });
      frames.push({ png: next, take: STEP });
      png = next;
      sig = nextSig;
    }

    const totalH = frames.reduce((h, f) => h + f.take, 0);
    const outPng = new PNG({ width: VIEW_W, height: totalH });
    let y = 0;
    for (const f of frames) {
      const srcStart = f.png.height - f.take; // 0 for frame 0
      f.png.data.copy(
        outPng.data,
        y * VIEW_W * 4,
        srcStart * VIEW_W * 4,
        f.png.height * VIEW_W * 4,
      );
      y += f.take;
    }
    fs.writeFileSync(out, PNG.sync.write(outPng));
    fs.writeFileSync(
      out.replace(/\.png$/, '.json'),
      JSON.stringify({ url, theme, totalH, frames: frames.length, advances }),
    );
    console.log(
      `captured ${out}: ${VIEW_W}x${totalH} in ${frames.length} frames`,
    );
  } finally {
    await browser.close();
  }
})().catch((e) => {
  console.error('CAPTURE FAILED', e.message);
  process.exit(1);
});
