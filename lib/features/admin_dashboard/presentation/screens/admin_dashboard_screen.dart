import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/admin_dashboard_cubit.dart';
import '../../../../core/constants/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminDashboardCubit>().loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            color: AppColors.primary,
            child: Column(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      'MAW3IDI ADMIN',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.white),
                  title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.people, color: Colors.white),
                  title: const Text('Users', style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.delivery_dining, color: Colors.white),
                  title: const Text('Drivers', style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag, color: Colors.white),
                  title: const Text('Orders', style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              color: AppColors.background,
              child: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
                builder: (context, state) {
                  if (state is AdminDashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminDashboardLoaded) {
                    final stats = state.stats;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dashboard Overview',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            _buildStatCard('Total Users', stats['totalUsers'].toString(), Icons.people, Colors.blue),
                            _buildStatCard('Total Drivers', stats['totalDrivers'].toString(), Icons.delivery_dining, Colors.green),
                            _buildStatCard('Active Orders', stats['activeOrders'].toString(), Icons.shopping_cart, Colors.orange),
                            _buildStatCard('Total Earnings', '${stats['totalEarnings']} SAR', Icons.attach_money, Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 48),
                        const Text(
                          'Recent Activity',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Card(
                            child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) => ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.shopping_basket)),
                                title: Text('Order #${1020 + index}'),
                                subtitle: const Text('Completed by Driver Ahmed'),
                                trailing: const Text('10 mins ago'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is AdminDashboardError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
