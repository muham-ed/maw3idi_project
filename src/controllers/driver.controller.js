const User = require('../models/user.model');
const Order = require('../models/order.model');

exports.updateStatus = async (req, res) => {
  try {
    const { isOnline } = req.body;
    const driverId = req.userData.userId;

    const driver = await User.findByPk(driverId);
    if (driver) {
      driver.isOnline = isOnline;
      await driver.save();
      res.status(200).json({ message: `Status updated to ${isOnline ? 'Online' : 'Offline'}`, isOnline });
    } else {
      res.status(404).json({ message: 'Driver not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getAvailableOrders = async (req, res) => {
  try {
    const availableOrders = await Order.findAll({ where: { status: 'pending', driverId: null } });
    res.status(200).json(availableOrders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.acceptOrder = async (req, res) => {
  try {
    const driverId = req.userData.userId;
    const orderId = req.params.id;

    const order = await Order.findByPk(orderId);
    if (order && order.status === 'pending') {
      order.driverId = driverId;
      order.status = 'accepted';
      await order.save();

      // Notify client
      req.io.to(`order_${order.id}`).emit('status_changed', { status: 'accepted' });

      res.status(200).json(order);
    } else {
      res.status(400).json({ message: 'Order not available' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
