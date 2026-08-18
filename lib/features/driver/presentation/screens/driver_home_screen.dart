import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/driver_cubit.dart';
import '../../../../core/constants/app_colors.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          Row(
            children: [
              Text(_isOnline ? 'Online' : 'Offline', 
                style: TextStyle(color: _isOnline ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
              Switch(
                value: _isOnline,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _isOnline = value;
                  });
                  context.read<DriverCubit>().updateStatus(value);
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<DriverCubit, DriverState>(
        builder: (context, state) {
          if (!_isOnline) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('You are currently Offline', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text('Go Online to start receiving orders', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          if (state is DriverLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DriverOrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text('No available orders nearby'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('${order['total']} SAR', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.location_on, color: Colors.red),
                          title: const Text('Pickup'),
                          subtitle: Text(order['pickupAddress']),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.navigation, color: Colors.green),
                          title: const Text('Delivery'),
                          subtitle: Text(order['deliveryAddress']),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<DriverCubit>().acceptOrder(order['id']);
                                },
                                child: const Text('Accept'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is DriverError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('Waiting for orders...'));
        },
      ),
    );
  }
}
