const express = require('express');
const healthRouter = require('./health');
const statusRouter = require('./status');
const processRouter = require('./process');

module.exports = {
  healthRouter,
  statusRouter,
  processRouter
};
