const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Order = sequelize.define('Order', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  total: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
    defaultValue: 0.00
  },
  fare: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
    defaultValue: 0.00
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  pickupAddress: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  dropoffAddress: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  pickupLat: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  pickupLng: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  dropoffLat: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  dropoffLng: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  driverLat: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  driverLng: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  estimatedDistanceKm: {
    type: DataTypes.DOUBLE,
    allowNull: true
  },
  estimatedDurationMin: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  serviceType: {
    type: DataTypes.ENUM('ride', 'delivery'),
    defaultValue: 'ride'
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'driver_arrived', 'in_trip', 'completed', 'cancelled'),
    defaultValue: 'pending'
  },
  clientId: {
    type: DataTypes.UUID,
    allowNull: false
  },
  driverId: {
    type: DataTypes.UUID,
    allowNull: true
  }
});

module.exports = Order;

