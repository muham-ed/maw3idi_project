const express = require('express');
const router = express.Router();
const driverController = require('../controllers/driver.controller');
const authMiddleware = require('../middleware/auth.middleware');

const upload = require('../middleware/upload.middleware');

router.patch('/status', authMiddleware, driverController.updateStatus);
router.get('/available-orders', authMiddleware, driverController.getAvailableOrders);
router.post('/accept-order/:id', authMiddleware, driverController.acceptOrder);
router.patch('/progress/:id', authMiddleware, driverController.updateRideProgress);
router.post('/upload-docs', authMiddleware, upload.single('document'), (req, res) => {
  res.status(200).json({ message: 'Document uploaded successfully', file: req.file.filename });
});

module.exports = router;
