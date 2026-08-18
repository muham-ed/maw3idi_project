const express = require('express');
const router = express.Router();
const statsController = require('../../controllers/admin/stats.controller');
const authMiddleware = require('../../middleware/auth.middleware');

// In a real app, you'd check for 'admin' role here
router.get('/stats', authMiddleware, statsController.getDashboardStats);
router.get('/users', authMiddleware, statsController.getUsers);

module.exports = router;
