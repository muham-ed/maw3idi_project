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
    allowNull: false
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  status: {
    type: DataTypes.ENUM('pending', 'accepted', 'on_way', 'delivered', 'cancelled'),
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
