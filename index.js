const express = require('express');
const cors = require('cors');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST", "PATCH"]
  }
});

const PORT = process.env.PORT || 3000;
const sequelize = require('./src/config/database');

app.use(cors());
app.use(express.json());

// Socket.io Logic
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  socket.on('join_order', (orderId) => {
    socket.join(`order_${orderId}`);
    console.log(`Socket ${socket.id} joined order room: order_${orderId}`);
  });

  socket.on('join_driver_room', (driverId) => {
    socket.join(`driver_${driverId}`);
    console.log(`Driver ${driverId} joined room driver_${driverId}`);
  });

  socket.on('driver_online', (data) => {
    socket.join('online_drivers');
    console.log(`Driver ${data?.driverId || socket.id} is now ONLINE`);
  });

  socket.on('driver_offline', (data) => {
    socket.leave('online_drivers');
    console.log(`Driver ${data?.driverId || socket.id} is now OFFLINE`);
  });

  socket.on('update_location', (data) => {
    // data: { orderId, driverId, lat, lng, bearing }
    if (data.orderId) {
      io.to(`order_${data.orderId}`).emit('location_updated', {
        lat: data.lat,
        lng: data.lng,
        bearing: data.bearing || 0
      });
    }
  });

  socket.on('ride_status_update', (data) => {
    // data: { orderId, status }
    io.to(`order_${data.orderId}`).emit('status_changed', {
      status: data.status
    });
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Attach io to request for use in controllers
app.use((req, res, next) => {
  req.io = io;
  next();
});

const User = require('./src/models/user.model');
const Store = require('./src/models/store.model');
const Product = require('./src/models/product.model');
const Order = require('./src/models/order.model');
const MicrobusStation = require('./src/models/microbus_station.model');
const MicrobusRoute = require('./src/models/microbus_route.model');
const ViolationReport = require('./src/models/violation_report.model');

// Associations
Store.hasMany(Product, { foreignKey: 'storeId' });
Product.belongsTo(Store, { foreignKey: 'storeId' });

User.hasMany(Order, { foreignKey: 'clientId', as: 'clientOrders' });
User.hasMany(Order, { foreignKey: 'driverId', as: 'driverOrders' });
Order.belongsTo(User, { foreignKey: 'clientId', as: 'client' });
Order.belongsTo(User, { foreignKey: 'driverId', as: 'driver' });

MicrobusRoute.belongsTo(MicrobusStation, { as: 'startStation', foreignKey: 'start_station_id' });
MicrobusRoute.belongsTo(MicrobusStation, { as: 'endStation', foreignKey: 'end_station_id' });

ViolationReport.belongsTo(Order, { foreignKey: 'order_id' });
ViolationReport.belongsTo(User, { as: 'reporter', foreignKey: 'reporter_id' });
ViolationReport.belongsTo(User, { as: 'provider', foreignKey: 'provider_id' });

// Sync Database
sequelize.sync({ alter: true })
  .then(() => console.log('Database connected and synced'))
  .catch(err => console.error('Database connection error:', err));

// Basic Route
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to Maw3idi API' });
});

// Import Routes
const authRoutes = require('./src/routes/auth.routes');
const productRoutes = require('./src/routes/product.routes');
const storeRoutes = require('./src/routes/store.routes');
const orderRoutes = require('./src/routes/order.routes');
const adminRoutes = require('./src/routes/admin/admin.routes');
const driverRoutes = require('./src/routes/driver.routes');

app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/products', productRoutes);
app.use('/api/v1/stores', storeRoutes);
app.use('/api/v1/orders', orderRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1/driver', driverRoutes);

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Server is running on http://192.168.1.5:${PORT}`);
});
