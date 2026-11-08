const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const MicrobusStation = sequelize.define('MicrobusStation', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  latitude: {
    type: DataTypes.DECIMAL(9, 6),
    allowNull: false
  },
  longitude: {
    type: DataTypes.DECIMAL(9, 6),
    allowNull: false
  }
}, {
  tableName: 'microbus_stations',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false
});

module.exports = MicrobusStation;
