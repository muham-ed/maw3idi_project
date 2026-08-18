import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/profile_cubit.dart';
import '../../../../core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  const Divider(),
                  _buildProfileItem(Icons.phone, 'Phone', user.phone ?? 'Not set'),
                  _buildProfileItem(Icons.location_on, 'Saved Addresses', 'Riyadh, Saudi Arabia'),
                  _buildProfileItem(Icons.history, 'Order History', 'View past orders', onTap: () {
                    // Navigate to Order History
                  }),
                  _buildProfileItem(Icons.settings, 'Settings', 'Manage your account'),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
