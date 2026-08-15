// Pixel diff with an anti-aliasing control: full-res AA-aware, full-res raw,
// and a 50%-downscale pass (box average) that melts single-pixel glyph-AA
// noise while keeping real geometry drift visible.
//
// usage: node diff.js <a.png> <b.png> <diff.png>
const fs = require('fs');
const { PNG } = require('pngjs');
const pixelmatch = require('pixelmatch');

const [aPath, bPath, outPath] = process.argv.slice(2);
// The scrollbar thumb's position/length legitimately differs when total
// heights differ by a hair; keep it out of the score.
const CROP_RIGHT = 16;
const a = PNG.sync.read(fs.readFileSync(aPath));
const b = PNG.sync.read(fs.readFileSync(bPath));

if (a.width !== b.width) {
  console.error(`width mismatch: ${a.width} vs ${b.width}`);
  process.exit(2);
}
const w = a.width - CROP_RIGHT;
const h = Math.min(a.height, b.height);
const dh = a.height - b.height;

function crop(png, width, height) {
  const out = new PNG({ width, height });
  for (let y = 0; y < height; y++) {
    png.data.copy(
      out.data,
      y * width * 4,
      y * png.width * 4,
      y * png.width * 4 + width * 4,
    );
  }
  return out;
}
const ca = crop(a, w, h);
const cb = crop(b, w, h);

// Where does disagreement START? Row-level SAD scan localizes drift to a
// section instead of smearing it over a percentage. Two thresholds: >12 is
// "any disagreement past noise" (glyph AA trips it), >40 sustained over
// three consecutive rows is structural — doubled text, shifted layout.
function rowSad(y) {
  let sad = 0;
  let count = 0;
  for (let x = 0; x < w; x += 4) {
    const i = (y * w + x) * 4;
    sad +=
      Math.abs(ca.data[i] - cb.data[i]) +
      Math.abs(ca.data[i + 1] - cb.data[i + 1]) +
      Math.abs(ca.data[i + 2] - cb.data[i + 2]);
    count++;
  }
  return sad / count;
}

function firstDivergentRow() {
  for (let y = 0; y < h; y++) {
    if (rowSad(y) > 12) return y;
  }
  return -1;
}

function firstStructuralRow() {
  let run = 0;
  for (let y = 0; y < h; y++) {
    run = rowSad(y) > 40 ? run + 1 : 0;
    if (run >= 3) return y - 2;
  }
  return -1;
}

const diff = new PNG({ width: w, height: h });
const aaAware = pixelmatch(ca.data, cb.data, diff.data, w, h, {
  threshold: 0.12,
});
fs.writeFileSync(outPath, PNG.sync.write(diff));
const raw = pixelmatch(ca.data, cb.data, null, w, h, {
  threshold: 0.12,
  includeAA: true,
});

function half(png) {
  const hw = png.width >> 1;
  const hh = png.height >> 1;
  const out = new PNG({ width: hw, height: hh });
  for (let y = 0; y < hh; y++) {
    for (let x = 0; x < hw; x++) {
      for (let ch = 0; ch < 4; ch++) {
        const i = (2 * y * png.width + 2 * x) * 4 + ch;
        const j = i + 4;
        const k = i + png.width * 4;
        const l = k + 4;
        out.data[(y * hw + x) * 4 + ch] =
          (png.data[i] + png.data[j] + png.data[k] + png.data[l]) >> 2;
      }
    }
  }
  return out;
}
const ha = half(ca);
const hb = half(cb);
const halfDiff = pixelmatch(ha.data, hb.data, null, ha.width, ha.height, {
  threshold: 0.12,
});

const total = w * h;
console.log(
  JSON.stringify({
    a: aPath,
    b: bPath,
    heightA: a.height,
    heightB: b.height,
    dHeight: dh,
    comparedPx: total,
    rawDiff: raw,
    rawPct: +((100 * raw) / total).toFixed(3),
    aaAwareDiff: aaAware,
    aaAwarePct: +((100 * aaAware) / total).toFixed(3),
    halfResDiff: halfDiff,
    halfResPct: +((100 * halfDiff) / (ha.width * ha.height)).toFixed(3),
    firstDivergentRow: firstDivergentRow(),
    firstStructuralRow: firstStructuralRow(),
  }),
);
