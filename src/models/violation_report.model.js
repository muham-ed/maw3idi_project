const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ViolationReport = sequelize.define('ViolationReport', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  orderId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'order_id'
  },
  reporterId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'reporter_id'
  },
  providerId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'provider_id'
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  gpsLocation: {
    type: DataTypes.JSONB,
    allowNull: true,
    field: 'gps_location'
  },
  status: {
    type: DataTypes.ENUM('pending', 'approved', 'rejected'),
    defaultValue: 'pending'
  },
  penaltyAmount: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
    field: 'penalty_amount'
  }
}, {
  tableName: 'violation_reports',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false
});

module.exports = ViolationReport;
