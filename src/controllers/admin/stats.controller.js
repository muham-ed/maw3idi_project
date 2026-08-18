exports.getDashboardStats = async (req, res) => {
  res.status(200).json({
    totalUsers: 150,
    totalDrivers: 45,
    totalOrders: 1200,
    totalEarnings: 45000,
    activeOrders: 12
  });
};

exports.getUsers = async (req, res) => {
  // Mock users list
  res.status(200).json([
    { id: '1', name: 'User One', role: 'client', joined: '2023-10-01' },
    { id: '2', name: 'User Two', role: 'driver', joined: '2023-10-05' }
  ]);
};
