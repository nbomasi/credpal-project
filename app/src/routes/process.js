const express = require('express');
const router = express.Router();

router.post('/', (req, res) => {
  const { data } = req.body || {};
  const id = `proc_${Date.now()}`;
  res.status(201).json({
    id,
    status: 'processed',
    received: data,
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
