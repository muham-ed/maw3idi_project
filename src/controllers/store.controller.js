const Store = require('../models/store.model');
const Product = require('../models/product.model');

exports.getStores = async (req, res) => {
  try {
    const stores = await Store.findAll();
    res.status(200).json(stores);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.getStoreProducts = async (req, res) => {
  try {
    const products = await Product.findAll({ where: { storeId: req.params.id } });
    res.status(200).json(products);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
