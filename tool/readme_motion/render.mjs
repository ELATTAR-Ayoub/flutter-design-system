// Renders scene.html frame by frame and encodes the README motion assets.
//
//   node tool/readme_motion/render.mjs            full render → docs/assets/launch/
//   node tool/readme_motion/render.mjs --stills   a few stills into .tmp/readme_motion/
//
// Needs Playwright (a global `npm i -g playwright` is found too) with a local
// Chrome, and ffmpeg on PATH.
import { execFileSync, execSync } from 'node:child_process';
import { mkdirSync, rmSync } from 'node:fs';
import { createRequire } from 'node:module';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const require = createRequire(import.meta.url);
const globalRoot = execSync('npm root -g', { encoding: 'utf8' }).trim();
const { chromium } = require(require.resolve('playwright', { paths: [process.cwd(), globalRoot] }));

const here = dirname(fileURLToPath(import.meta.url));
const root = resolve(here, '../..');
const work = join(root, '.tmp/readme_motion');
const out = join(root, 'docs/assets/launch');
const FPS = 30;
const stills = process.argv.includes('--stills');

const browser = await chromium.launch({ channel: 'chrome' });
const page = await browser.newPage({ viewport: { width: 1600, height: 800 } });
await page.goto(pathToFileURL(join(here, 'scene.html')).href);
await page.evaluate(() => window.ready);
const T = await page.evaluate(() => window.T);

if (stills) {
  mkdirSync(work, { recursive: true });
  const times = process.argv.slice(3).map(Number).filter((n) => !Number.isNaN(n));
  for (const t of times.length ? times : [1.4, 2.9, 5.5, 7.4, 8.4, 9.3, 11.0, 13.0]) {
    await page.evaluate((t) => window.seek(t), t);
    await page.screenshot({ path: join(work, `still-${t.toFixed(2)}.png`) });
  }
  await browser.close();
  process.exit(0);
}

const frames = join(work, 'frames');
rmSync(frames, { recursive: true, force: true });
mkdirSync(frames, { recursive: true });
const total = Math.round(T * FPS);
for (let i = 0; i < total; i++) {
  await page.evaluate((t) => window.seek(t), i / FPS);
  await page.screenshot({ path: join(frames, `f${String(i).padStart(4, '0')}.png`) });
}
await browser.close();

const input = ['-y', '-v', 'error', '-framerate', String(FPS), '-i', join(frames, 'f%04d.png')];
execFileSync('ffmpeg', [...input, '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '18', '-preset', 'slow',
  '-movflags', '+faststart', join(out, 'elattar-quickstart.mp4')], { stdio: 'inherit' });
execFileSync('ffmpeg', [...input, '-vf', 'fps=24,scale=1200:-1:flags=lanczos', '-c:v', 'libwebp_anim',
  '-quality', '72', '-compression_level', '6', '-loop', '0', join(out, 'elattar-quickstart.webp')], { stdio: 'inherit' });
console.log(`rendered ${total} frames`);
