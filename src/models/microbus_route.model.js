const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const MicrobusRoute = sequelize.define('MicrobusRoute', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  startStationId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'start_station_id'
  },
  endStationId: {
    type: DataTypes.UUID,
    allowNull: false,
    field: 'end_station_id'
  },
  officialPrice: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
    field: 'official_price'
  }
}, {
  tableName: 'microbus_routes',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false
});

module.exports = MicrobusRoute;
