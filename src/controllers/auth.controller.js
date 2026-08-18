const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const User = require('../models/user.model');
const { Op } = require('sequelize');

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    // Allow login by email or phone
    const user = await User.findOne({
      where: {
        [Op.or]: [
          { email: email || '' },
          { phone: email || '' }
        ]
      }
    });

    if (!user) {
      return res.status(401).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { userId: user.id, role: user.role },
      process.env.JWT_SECRET || 'secret_key',
      { expiresIn: '24h' }
    );

    res.status(200).json({
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      token: token
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.register = async (req, res) => {
  try {
    const { name, email, phone, role, password } = req.body;

    const existingUser = await User.findOne({
      where: {
        [Op.or]: [{ email }, { phone }]
      }
    });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    const hashedPassword = await bcrypt.hash(password || 'password', 12);

    const newUser = await User.create({
      name,
      email,
      phone,
      role: role || 'client',
      password: hashedPassword
    });

    const token = jwt.sign(
      { userId: newUser.id, role: newUser.role },
      process.env.JWT_SECRET || 'secret_key',
      { expiresIn: '24h' }
    );

    res.status(201).json({
      id: newUser.id,
      name: newUser.name,
      email: newUser.email,
      role: newUser.role,
      token: token
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

exports.sendOTP = async (req, res) => {
  const { phone } = req.body;
  console.log(`Sending OTP to ${phone}`);
  res.status(200).json({ message: 'OTP sent successfully' });
};

exports.verifyOTP = async (req, res) => {
  const { phone, otp } = req.body;
  // Simplified for demo - finding user by phone
  const user = await User.findOne({ where: { phone } });
  if (user) {
    const token = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_SECRET || 'secret_key', { expiresIn: '24h' });
    res.status(200).json({
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      token: token
    });
  } else {
    res.status(404).json({ message: 'User not found' });
  }
};
