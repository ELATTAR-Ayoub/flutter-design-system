// Static server with an index.html fallback for Flutter's path URL strategy.
//
// usage: node serve-spa.js <web-root> [port=8321]
const fs = require('fs');
const http = require('http');
const path = require('path');

const [rootArg, portArg] = process.argv.slice(2);
if (!rootArg) {
  console.error('usage: node serve-spa.js <web-root> [port=8321]');
  process.exit(64);
}

const root = path.resolve(rootArg);
const port = Number(portArg || 8321);
const mime = {
  '.css': 'text/css',
  '.html': 'text/html',
  '.ico': 'image/x-icon',
  '.js': 'text/javascript',
  '.json': 'application/json',
  '.otf': 'font/otf',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.wasm': 'application/wasm',
  '.woff2': 'font/woff2',
};

http.createServer((request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);
  const requested = path.resolve(root, `.${decodeURIComponent(url.pathname)}`);
  const insideRoot = requested === root || requested.startsWith(`${root}${path.sep}`);
  const candidate = insideRoot && fs.existsSync(requested) && fs.statSync(requested).isFile()
    ? requested
    : path.join(root, 'index.html');

  fs.readFile(candidate, (error, bytes) => {
    if (error) {
      response.writeHead(404, { 'Content-Type': 'text/plain' });
      response.end('Not found');
      return;
    }
    response.writeHead(200, {
      'Content-Type': mime[path.extname(candidate)] || 'application/octet-stream',
    });
    response.end(bytes);
  });
}).listen(port, '127.0.0.1', () => {
  console.log(`Serving ${root} at http://127.0.0.1:${port}`);
});
