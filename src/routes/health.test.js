const { describe, it } = require('node:test');
const assert = require('node:assert');
const http = require('node:http');
const app = require('../app');

describe('Health endpoint', () => {
  it('GET /health returns healthy status', (t, done) => {
    const server = app.listen(0, () => {
      const port = server.address().port;
      const req = http.request(
        {
          hostname: 'localhost',
          port,
          path: '/health',
          method: 'GET'
        },
        (res) => {
          let data = '';
          res.on('data', (chunk) => (data += chunk));
          res.on('end', () => {
            const body = JSON.parse(data);
            assert.strictEqual(res.statusCode, 200);
            assert.strictEqual(body.status, 'healthy');
            assert.ok(body.timestamp);
            assert.ok(typeof body.uptime === 'number');
            server.close();
            done();
          });
        }
      );
      req.on('error', (err) => {
        server.close();
        done(err);
      });
      req.end();
    });
  });
});
