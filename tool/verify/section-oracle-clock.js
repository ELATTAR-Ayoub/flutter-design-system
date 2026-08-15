// Section oracle with a frozen Date shim (Proxy over Date + Date.now shift).
const puppeteer = require('puppeteer-core');
(async () => {
  const route = process.argv[2];
  const iso = process.argv[3] || '2026-08-16T12:00:00';
  const b = await puppeteer.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true, args: ['--force-device-scale-factor=1', '--window-size=1440,1000'] });
  try {
    const p = await b.newPage();
    await p.setViewport({ width: 1440, height: 900 });
    await p.evaluateOnNewDocument((fixedIso) => {
      const OrigDate = Date;
      const fixed = new OrigDate(fixedIso).getTime();
      const offset = fixed - OrigDate.now();
      const now = () => OrigDate.now() + offset;
      const Shim = new Proxy(OrigDate, {
        construct(t, args) { return args.length ? new t(...args) : new t(now()); },
        apply() { return new OrigDate(now()).toString(); },
        get(t, k) { return k === 'now' ? now : t[k]; },
      });
      window.Date = Shim;
    }, iso);
    await p.goto(`http://localhost:3000${route}`, { waitUntil: 'networkidle2', timeout: 120000 });
    try { await p.evaluate(() => document.fonts && document.fonts.ready); } catch (_) {}
    await new Promise(r => setTimeout(r, 1500));
    const report = await p.evaluate(() => {
      const abs = (el) => { const r = el.getBoundingClientRect(); return { top: +(r.top + window.scrollY).toFixed(1), height: +r.height.toFixed(1) }; };
      const sections = [...document.querySelectorAll('section[id], [id]')].filter((el) => el.id && el.closest('main')).map((el) => ({ id: el.id, ...abs(el) }));
      const caption = document.querySelector('[data-slot="calendar"] [class*="caption"], [data-slot="calendar"]');
      return { scrollHeight: document.documentElement.scrollHeight, main: abs(document.querySelector('main')), calendarSeen: caption ? caption.textContent.slice(0, 60) : null, sections };
    });
    console.log(JSON.stringify({ route, clock: iso, ...report }));
  } finally { await b.close(); }
})().catch((e) => { console.error('ORACLE FAILED', e.message); process.exit(1); });
