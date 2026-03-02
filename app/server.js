const http = require('http');
const os = require('os');

// Track restarts using a startup time
const startTime = new Date().toISOString();
let requestCount = 0;

const server = http.createServer((req, res) => {
  requestCount++;

  // Health check endpoint - Kubernetes uses this
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'healthy', uptime: process.uptime().toFixed(1) + 's' }));
    return;
  }

  // Crash endpoint - to DEMO self-healing to sir!
  if (req.url === '/crash') {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end('<h1>💥 App is crashing! Watch Kubernetes restart it automatically...</h1>');
    setTimeout(() => process.exit(1), 500); // crash after sending response
    return;
  }

  // Main page
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(`
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Kubernetes Live Demo</title>
  <meta http-equiv="refresh" content="3">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Segoe UI', sans-serif; background: #0D1B40; color: white; padding: 30px; }
    h1 { color: #22D3EE; font-size: 2rem; margin-bottom: 10px; }
    .subtitle { color: #94A3B8; margin-bottom: 30px; font-size: 0.95rem; }
    .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
    .card { background: #1E3158; border-radius: 12px; padding: 20px; border: 1px solid #1E4080; }
    .card h3 { color: #22D3EE; margin-bottom: 12px; font-size: 0.9rem; letter-spacing: 1px; text-transform: uppercase; }
    .val { font-size: 1.3rem; font-weight: bold; color: white; }
    .label { color: #94A3B8; font-size: 0.8rem; margin-top: 4px; }
    .tag { display: inline-block; background: #0D9488; color: white; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; margin: 3px; }
    .tag.red { background: #991B1B; }
    .demo-buttons { display: flex; gap: 15px; flex-wrap: wrap; margin-top: 20px; }
    .btn { padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 0.9rem; border: none; cursor: pointer; }
    .btn-teal { background: #0D9488; color: white; }
    .btn-red { background: #991B1B; color: white; }
    .pulse { animation: pulse 2s infinite; }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.5} }
    .badge { background: #065F46; color: #6EE7B7; padding: 3px 10px; border-radius: 10px; font-size: 0.75rem; }
  </style>
</head>
<body>
  <h1>🚀 Kubernetes Live Demo</h1>
  <p class="subtitle">This page auto-refreshes every 3 seconds — watch the values change as K8s manages this app</p>

  <div class="grid">
    <div class="card">
      <h3>📦 This Container / Pod</h3>
      <div class="val">${os.hostname()}</div>
      <div class="label">Pod Name (hostname)</div>
      <br>
      <div class="val" style="color:#6EE7B7">${startTime}</div>
      <div class="label">Started At (changes if K8s restarts this pod)</div>
    </div>

    <div class="card">
      <h3>💻 Linux Server Info</h3>
      <div class="val">${os.platform()} / ${os.arch()}</div>
      <div class="label">OS / Architecture</div>
      <br>
      <div class="val">${(os.freemem() / 1024 / 1024).toFixed(0)} MB free</div>
      <div class="label">Available Memory (Linux controls this via cgroups)</div>
    </div>

    <div class="card">
      <h3>⏱️ Uptime & Requests</h3>
      <div class="val pulse">${process.uptime().toFixed(1)}s</div>
      <div class="label">This container has been running for</div>
      <br>
      <div class="val">${requestCount}</div>
      <div class="label">Requests served (resets when K8s restarts pod)</div>
    </div>

    <div class="card">
      <h3>🌐 Network</h3>
      <div class="val">${Object.values(os.networkInterfaces()).flat().find(i => i.family === 'IPv4' && !i.internal)?.address || 'N/A'}</div>
      <div class="label">Pod IP (assigned by K8s / Linux networking)</div>
      <br>
      <span class="badge">✔ Health: OK</span>
    </div>
  </div>

  <div class="card" style="margin-bottom:20px">
    <h3>🎯 Demo Actions — Show These to Sir</h3>
    <p style="color:#94A3B8; font-size:0.85rem; margin-bottom:15px">These buttons demonstrate the 3 KEY features of Kubernetes live:</p>
    <div class="demo-buttons">
      <a href="/crash" class="btn btn-red">💥 CRASH this app</a>
      <span style="color:#94A3B8; font-size:0.85rem; align-self:center">→ Then watch Kubernetes restart it automatically in the terminal!</span>
    </div>
    <p style="color:#6EE7B7; font-size:0.8rem; margin-top:12px">✔ After crash: run <code style="background:#0D1B40;padding:2px 6px;border-radius:4px">kubectl get pods --watch</code> to see K8s self-healing in real time</p>
  </div>

  <div class="card">
    <h3>📋 What Kubernetes Is Doing Right Now</h3>
    <span class="tag">✔ Running health checks every 10s</span>
    <span class="tag">✔ Monitoring CPU & memory via Linux cgroups</span>
    <span class="tag">✔ Ready to restart if this pod crashes</span>
    <span class="tag">✔ Ready to scale up if traffic grows</span>
    <span class="tag red">⟳ Auto-refreshing every 3 seconds</span>
  </div>
</body>
</html>
  `);
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`✅ App started on port ${PORT}`);
  console.log(`📦 Pod name: ${os.hostname()}`);
  console.log(`🕐 Start time: ${startTime}`);
});
