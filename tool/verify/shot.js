// Single-viewport screenshot at an arbitrary size, with a fixed settle.
//
// usage: node shot.js <url> <out.png> [width=1440] [height=900] [settle=6000]
//
// `capture.js` is the parity rig: it stitches a full page at 1440x900 and its
// frame matcher is tuned to that layout (the content clip at x∈[248,1424) is
// the docs shell's own geometry). Two things it therefore cannot do, and this
// can:
//
//   * Narrow widths. Below the sidebar breakpoint the shell reflows — there is
//     no rail to exclude — so the matcher's clip is meaningless and stitching
//     would report advances that are not there. A narrow review wants the
//     first viewport anyway.
//   * Pages that never go network-idle. `capture.js --nav domcontentloaded`
//     covers most of those; this covers the rest, and prints the console and
//     the still-pending requests, which is how you find out WHY a page never
//     settled rather than guessing.
//
// It deliberately does not stitch: what it returns is one viewport, and a
// review that uses it should say so.
const puppeteer = require('puppeteer-core');

const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';

(async () => {
  const [url, out, ws, hs, settleS] = process.argv.slice(2);
  if (!url || !out) {
    console.error('usage: node shot.js <url> <out.png> [w] [h] [settle]');
    process.exit(64);
  }
  const W = +ws || 1440;
  const H = +hs || 900;
  const settle = +settleS || 6000;

  const browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: 'new',
    args: [
      `--window-size=${W},${H + 120}`,
      // Same colour and text flags as capture.js: grayscale AA on both sides,
      // sRGB, no device-pixel scaling. A review comparing the two must not be
      // comparing rasterisation settings.
      '--force-color-profile=srgb',
      '--force-device-scale-factor=1',
      '--disable-lcd-text',
    ],
  });

  const page = await browser.newPage();
  await page.setViewport({ width: W, height: H, deviceScaleFactor: 1 });

  const pending = new Set();
  page.on('request', (r) => pending.add(r.url()));
  page.on('requestfinished', (r) => pending.delete(r.url()));
  page.on('requestfailed', (r) => pending.delete(r.url()));

  const logs = [];
  page.on('console', (m) => logs.push(`[${m.type()}] ${m.text()}`));
  page.on('pageerror', (e) => logs.push(`[pageerror] ${e.message}`));

  try {
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
  } catch (e) {
    logs.push(`[goto] ${e.message}`);
  }
  await new Promise((r) => setTimeout(r, settle));
  // Cursor discipline, as in capture.js: a resting pointer hovers whatever is
  // under it, and Flutter re-hit-tests on every frame.
  await page.mouse.move(8, 8);
  await page.screenshot({ path: out });

  console.log(`captured ${out} ${W}x${H}`);
  if (pending.size) {
    console.log('still pending:\n  ' + [...pending].slice(0, 8).join('\n  '));
  }
  if (logs.length) console.log('console:\n  ' + logs.slice(0, 20).join('\n  '));
  await browser.close();
})();
