const express = require('express');
const path = require('path');
const { healthRouter, statusRouter, processRouter } = require('./routes');
const { requestLogger } = require('./middleware/logger');

const app = express();

app.use(express.json());
app.use(requestLogger);

app.use('/health', healthRouter);
app.use('/status', statusRouter);
app.use('/process', processRouter);

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

app.use(express.static(path.join(__dirname, '..', 'public')));

app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({ error: 'Internal server error' });
});

module.exports = app;
