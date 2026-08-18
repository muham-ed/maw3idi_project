const Product = require('../models/product.model');

exports.getProducts = async (req, res) => {
  try {
    const products = await Product.findAll();
    // Seed some products if empty
    if (products.length === 0) {
      await Product.bulkCreate([
        { name: 'Burger King Meal', description: 'Delicious beef burger', price: 35.0, imageUrl: '' },
        { name: 'Pizza Hut Large', description: 'Pepperoni pizza', price: 45.0, imageUrl: '' }
      ]);
      return res.status(200).json(await Product.findAll());
    }
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
