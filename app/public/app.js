document.querySelectorAll('[data-endpoint]').forEach(btn => {
  btn.addEventListener('click', async () => {
    const endpoint = btn.dataset.endpoint;
    const method = btn.dataset.method;
    const output = document.getElementById('responseOutput');

    output.textContent = 'Loading...';

    try {
      const options = { method };
      if (method === 'POST') {
        options.headers = { 'Content-Type': 'application/json' };
        options.body = JSON.stringify({ data: { test: true, timestamp: new Date().toISOString() } });
      }
      const res = await fetch(endpoint, options);
      const data = await res.json();
      output.textContent = JSON.stringify(data, null, 2);
    } catch (err) {
      output.textContent = `Error: ${err.message}`;
    }
  });
});
