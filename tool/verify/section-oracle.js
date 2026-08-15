// Per-section geometry oracle from the live reference: every section id's
// document offsetTop and height, plus total scrollHeight, at 1440×900.
// usage: node section-oracle.js <route> [theme]
const puppeteer = require('puppeteer-core');

(async () => {
  const route = process.argv[2];
  const theme = process.argv[3] || 'light';
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe',
    headless: true,
    args: ['--force-device-scale-factor=1', '--window-size=1440,1000'],
  });
  try {
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 900 });
    await page.evaluateOnNewDocument((t) => {
      try {
        localStorage.setItem('theme', t);
      } catch (_) {}
    }, theme);
    await page.goto(`http://localhost:3000${route}`, {
      waitUntil: 'networkidle2',
      timeout: 120000,
    });
    try {
      await page.evaluate(() => document.fonts && document.fonts.ready);
    } catch (_) {}
    await new Promise((r) => setTimeout(r, 1500));
    const report = await page.evaluate(() => {
      const abs = (el) => {
        const r = el.getBoundingClientRect();
        return {
          top: +(r.top + window.scrollY).toFixed(1),
          height: +r.height.toFixed(1),
        };
      };
      const sections = [...document.querySelectorAll('section[id], [id]')]
        .filter((el) => el.id && el.closest('main'))
        .map((el) => ({ id: el.id, ...abs(el) }));
      const main = document.querySelector('main');
      return {
        scrollHeight: document.documentElement.scrollHeight,
        main: main ? abs(main) : null,
        sections,
      };
    });
    console.log(JSON.stringify({ route, theme, ...report }));
  } finally {
    await browser.close();
  }
})().catch((e) => {
  console.error('ORACLE FAILED', e.message);
  process.exit(1);
});
