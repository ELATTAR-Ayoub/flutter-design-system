// Current-tree visual smoke matrix for the highest-risk public routes.
//
// usage: node review-batch.js <base-url> <output-directory>
const fs = require('fs');
const path = require('path');
const puppeteer = require('puppeteer-core');

const CHROME = 'C:/Program Files/Google/Chrome/Application/chrome.exe';
const [baseArg, outputArg] = process.argv.slice(2);
if (!baseArg || !outputArg) {
  console.error('usage: node review-batch.js <base-url> <output-directory>');
  process.exit(64);
}

const base = baseArg.replace(/\/$/, '');
const output = path.resolve(outputArg);
const routes = [
  '/docs/typeset',
  '/components/button',
  '/components/select',
  '/components/dialog',
  '/components/chart',
  '/components/agent-console',
];
const viewports = [
  { name: 'mobile', width: 390, height: 844 },
  { name: 'tablet', width: 768, height: 1024 },
  { name: 'desktop', width: 1440, height: 900 },
];

(async () => {
  fs.mkdirSync(output, { recursive: true });
  const browser = await puppeteer.launch({
    executablePath: CHROME,
    headless: 'new',
    args: [
      '--force-color-profile=srgb',
      '--force-device-scale-factor=1',
      '--disable-lcd-text',
    ],
  });
  const manifest = [];

  // Warm CanvasKit and the packaged fonts once. Without this, the first cold
  // viewport can be captured before Flutter paints its first frame.
  const warmup = await browser.newPage();
  await warmup.goto(`${base}/?theme=dark`, {
    waitUntil: 'domcontentloaded',
    timeout: 60000,
  });
  await new Promise((resolve) => setTimeout(resolve, 4000));
  await warmup.close();

  for (const route of routes) {
    for (const theme of ['dark', 'light']) {
      for (const viewport of viewports) {
        const page = await browser.newPage();
        const messages = [];
        const failures = [];
        page.on('console', (message) => messages.push(`[${message.type()}] ${message.text()}`));
        page.on('pageerror', (error) => messages.push(`[pageerror] ${error.message}`));
        page.on('requestfailed', (request) => failures.push(request.url()));
        await page.setViewport({
          width: viewport.width,
          height: viewport.height,
          deviceScaleFactor: 1,
        });
        const url = `${base}${route}?theme=${theme}`;
        await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 60000 });
        await new Promise((resolve) => setTimeout(resolve, 1800));
        await page.evaluate(() => window.__elScrollTo?.(0));
        await new Promise((resolve) => setTimeout(resolve, 150));
        await page.mouse.move(8, 8);
        const slug = route.slice(1).replaceAll('/', '__');
        const file = `${slug}__${theme}__${viewport.name}.png`;
        await page.screenshot({ path: path.join(output, file) });
        manifest.push({ route, theme, ...viewport, file, messages, failures });
        await page.close();
      }
    }
  }

  fs.writeFileSync(
    path.join(output, 'manifest.json'),
    `${JSON.stringify(manifest, null, 2)}\n`,
  );
  await browser.close();
  console.log(`Captured ${manifest.length} current-tree viewports in ${output}`);
  console.log(`Console messages: ${manifest.reduce((sum, item) => sum + item.messages.length, 0)}`);
  console.log(`Failed requests: ${manifest.reduce((sum, item) => sum + item.failures.length, 0)}`);
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
