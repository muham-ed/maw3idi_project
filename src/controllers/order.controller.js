const Order = require('../models/order.model');

exports.createOrder = async (req, res) => {
  try {
    const {
      total,
      fare,
      address,
      pickupAddress,
      dropoffAddress,
      pickupLat,
      pickupLng,
      dropoffLat,
      dropoffLng,
      estimatedDistanceKm,
      estimatedDurationMin,
      serviceType
    } = req.body;

    const clientId = req.userData.userId;

    const newOrder = await Order.create({
      total: total || fare || 0.00,
      fare: fare || total || 0.00,
      address: address || dropoffAddress || 'Customer Location',
      pickupAddress: pickupAddress || 'Pickup Location',
      dropoffAddress: dropoffAddress || address || 'Dropoff Location',
      pickupLat: pickupLat || 24.7136,
      pickupLng: pickupLng || 46.6753,
      dropoffLat: dropoffLat || 24.7236,
      dropoffLng: dropoffLng || 46.6853,
      estimatedDistanceKm: estimatedDistanceKm || 5.2,
      estimatedDurationMin: estimatedDurationMin || 12,
      serviceType: serviceType || 'ride',
      clientId,
      status: 'pending'
    });

    // Notify online drivers
    req.io.to('online_drivers').emit('new_order_available', newOrder);
    req.io.emit('new_order_available', newOrder);

    res.status(201).json(newOrder);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getOrders = async (req, res) => {
  try {
    const orders = await Order.findAll({
      where: { clientId: req.userData.userId },
      order: [['createdAt', 'DESC']]
    });
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getOrderById = async (req, res) => {
  try {
    const order = await Order.findByPk(req.params.id);
    if (order) {
      res.status(200).json(order);
    } else {
      res.status(404).json({ message: 'Order not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findByPk(req.params.id);
    if (order) {
      order.status = status;
      await order.save();

      // Emit real-time update
      req.io.to(`order_${order.id}`).emit('status_changed', { status });

      res.status(200).json(order);
    } else {
      res.status(404).json({ message: 'Order not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
