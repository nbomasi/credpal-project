const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.json({
    status: 'operational',
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
