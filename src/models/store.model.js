const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Store = sequelize.define('Store', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT
  },
  logo: {
    type: DataTypes.STRING
  },
  rating: {
    type: DataTypes.FLOAT,
    defaultValue: 5.0
  },
  isOpen: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  category: {
    type: DataTypes.STRING // e.g., 'Restaurant', 'Pharmacy'
  }
});

module.exports = Store;
