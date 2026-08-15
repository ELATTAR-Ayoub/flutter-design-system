// Vertical alignment profile: for each y, the offset δ ∈ [−32..32] that best
// aligns an 8-row band of A at y with B at y+δ (content clip only). Where the
// pages agree δ=0; a layout drift shows as a step in δ. Prints transitions.
//
// usage: node locate.js <a.png> <b.png>
const fs = require('fs');
const { PNG } = require('pngjs');

const CLIP_X0 = 248;
const CLIP_X1 = 1424;
const BAND = 8;
const RANGE = 32;

const a = PNG.sync.read(fs.readFileSync(process.argv[2]));
const b = PNG.sync.read(fs.readFileSync(process.argv[3]));

function rowSig(png) {
  const sig = new Float64Array(png.height);
  for (let y = 0; y < png.height; y++) {
    let acc = 0;
    for (let x = CLIP_X0; x < CLIP_X1; x += 4) {
      const i = (y * png.width + x) * 4;
      acc += png.data[i] + png.data[i + 1] + png.data[i + 2];
    }
    sig[y] = acc;
  }
  return sig;
}

const sa = rowSig(a);
const sb = rowSig(b);
const h = Math.min(a.height, b.height);

function bandSad(y, delta) {
  let sad = 0;
  for (let r = 0; r < BAND; r++) {
    const ya = y + r;
    const yb = y + delta + r;
    if (yb < 0 || yb >= sb.length || ya >= sa.length) return Infinity;
    sad += Math.abs(sa[ya] - sb[yb]);
  }
  return sad / BAND;
}

let prev = 0;
const transitions = [];
for (let y = 0; y < h - BAND - RANGE; y += 2) {
  let best = { d: prev, sad: bandSad(y, prev) };
  for (let d = -RANGE; d <= RANGE; d++) {
    if (d === prev) continue;
    const sad = bandSad(y, d);
    // Prefer staying at the current offset unless another is clearly better.
    if (sad < best.sad * 0.6 - 1) best = { d, sad };
  }
  if (best.d !== prev) {
    transitions.push({ y, from: prev, to: best.d });
    prev = best.d;
  }
}
console.log(
  JSON.stringify({
    a: process.argv[2],
    b: process.argv[3],
    heights: [a.height, b.height],
    transitions,
  }),
);
