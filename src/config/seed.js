const sequelize = require('./database');
const User = require('../models/user.model');
const Store = require('../models/store.model');
const Product = require('../models/product.model');
const bcrypt = require('bcryptjs');

const seedDatabase = async () => {
  try {
    await sequelize.sync({ force: true });

    // Create Admin
    const adminPass = await bcrypt.hash('admin123', 12);
    await User.create({
      name: 'System Admin',
      email: 'admin@maw3idi.com',
      password: adminPass,
      role: 'admin',
      phone: '0522222222'
    });

    // Create Test Driver
    const driverPass = await bcrypt.hash('driver123', 12);
    await User.create({
      name: 'Ahmed Driver',
      email: 'driver@maw3idi.com',
      password: driverPass,
      role: 'driver',
      phone: '0500000000'
    });

    // Create Test Client
    const clientPass = await bcrypt.hash('client123', 12);
    await User.create({
      name: 'Sami Client',
      email: 'client@maw3idi.com',
      password: clientPass,
      role: 'client',
      phone: '0511111111'
    });

    // Create Stores
    const stores = await Store.bulkCreate([
      { name: 'Burger King', description: 'Home of the Whopper', category: 'Restaurant' },
      { name: 'Pizza Hut', description: 'Freshly baked pizzas', category: 'Restaurant' },
      { name: 'Panda Supermarket', description: 'Fresh groceries', category: 'Supermarket' }
    ]);

    // Create Products
    await Product.bulkCreate([
      { name: 'Whopper Meal', price: 45.0, storeId: stores[0].id },
      { name: 'Pepperoni Pizza', price: 55.0, storeId: stores[1].id },
      { name: 'Milk 1L', price: 7.0, storeId: stores[2].id }
    ]);

    console.log('Database seeded successfully! 🌱');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
};

seedDatabase();
