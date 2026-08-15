// usage: node crop.js <in.png> <out.png> <y0> <y1> [x0=0] [x1=width]
const fs = require('fs');
const { PNG } = require('pngjs');
const [inPath, outPath, y0s, y1s, x0s, x1s] = process.argv.slice(2);
const src = PNG.sync.read(fs.readFileSync(inPath));
const y0 = +y0s;
const y1 = Math.min(+y1s, src.height);
const x0 = x0s ? +x0s : 0;
const x1 = x1s ? Math.min(+x1s, src.width) : src.width;
const out = new PNG({ width: x1 - x0, height: y1 - y0 });
for (let y = y0; y < y1; y++) {
  src.data.copy(
    out.data,
    (y - y0) * out.width * 4,
    (y * src.width + x0) * 4,
    (y * src.width + x1) * 4,
  );
}
fs.writeFileSync(outPath, PNG.sync.write(out));
console.log(`${outPath}: ${out.width}x${out.height}`);
