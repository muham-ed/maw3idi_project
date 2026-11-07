import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../cubit/driver_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/services/directions_service.dart';
import '../../../../injection_container.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = false;
  final LocationService _locationService = LocationService();
  final SocketService _socketService = sl<SocketService>();

  Position? _currentPosition;
  String? _activeOrderId;
  String _activeTripStage = 'idle'; // idle | accepted | driver_arrived | in_trip | completed

  @override
  void initState() {
    super.initState();
    _socketService.onNewOrderAvailable((orderData) {
      if (_isOnline && _activeOrderId == null && mounted) {
        _showIncomingOrderDialog(orderData);
      }
    });
  }

  void _toggleOnlineStatus(bool value) async {
    setState(() {
      _isOnline = value;
    });

    _socketService.setDriverOnlineStatus(value, 'driver_123');
    context.read<DriverCubit>().updateStatus(value);

    if (value) {
      final pos = await _locationService.getCurrentPosition();
      if (pos != null) {
        setState(() => _currentPosition = pos);
      }

      _locationService.startLocationUpdates(
        onLocationChanged: (Position newPos) {
          if (mounted) {
            double bearing = 0.0;
            if (_currentPosition != null) {
              bearing = DirectionsService.calculateBearing(
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                LatLng(newPos.latitude, newPos.longitude),
              );
            }

            setState(() => _currentPosition = newPos);

            if (_activeOrderId != null) {
              _socketService.updateLocation(
                _activeOrderId!,
                newPos.latitude,
                newPos.longitude,
                bearing: bearing,
                driverId: 'driver_123',
              );
            }
          }
        },
      );
    } else {
      _locationService.stopLocationUpdates();
    }
  }

  void _showIncomingOrderDialog(Map<String, dynamic> order) {
    final String serviceType = (order['serviceType'] ?? 'RIDE').toString().toUpperCase();
    final String fareValue = (order['fare'] ?? order['total'] ?? 25.00).toString();

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      serviceType,
                      style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Text(
                    '$fareValue SAR',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.my_location, color: Colors.green),
                title: const Text('Pickup Address', style: TextStyle(fontSize: 12, color: Colors.grey)),
                subtitle: Text(order['pickupAddress'] ?? 'King Fahd Road, Riyadh', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text('Dropoff Address', style: TextStyle(fontSize: 12, color: Colors.grey)),
                subtitle: Text(order['dropoffAddress'] ?? 'Olaya Street, Riyadh', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _acceptTrip(order['id']?.toString() ?? 'order_123');
                      },
                      child: const Text('ACCEPT RIDE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _acceptTrip(String orderId) {
    setState(() {
      _activeOrderId = orderId;
      _activeTripStage = 'accepted';
    });
    _socketService.joinOrderRoom(orderId);
    _socketService.updateRideStatus(orderId, 'accepted');
  }

  void _advanceTripStage() {
    if (_activeOrderId == null) return;

    if (_activeTripStage == 'accepted') {
      setState(() => _activeTripStage = 'driver_arrived');
      _socketService.updateRideStatus(_activeOrderId!, 'driver_arrived');
    } else if (_activeTripStage == 'driver_arrived') {
      setState(() => _activeTripStage = 'in_trip');
      _socketService.updateRideStatus(_activeOrderId!, 'in_trip');
    } else if (_activeTripStage == 'in_trip') {
      setState(() {
        _activeTripStage = 'completed';
      });
      _socketService.updateRideStatus(_activeOrderId!, 'completed');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip completed successfully! Fare added to wallet.')),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _activeOrderId = null;
            _activeTripStage = 'idle';
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Terminal'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Text(
                _isOnline ? 'ONLINE' : 'OFFLINE',
                style: TextStyle(
                  color: _isOnline ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Switch(
                value: _isOnline,
                activeTrackColor: Colors.greenAccent,
                onChanged: _toggleOnlineStatus,
              ),
            ],
          ),
        ],
      ),
      body: !_isOnline
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('You are currently Offline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Go Online to receive ride & delivery requests', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : _activeOrderId != null
              ? _buildActiveTripDashboard()
              : _buildAvailableOrdersList(),
    );
  }

  Widget _buildActiveTripDashboard() {
    String buttonText = 'I HAVE ARRIVED AT PICKUP';
    Color buttonColor = Colors.orange;

    if (_activeTripStage == 'driver_arrived') {
      buttonText = 'START TRIP WITH CUSTOMER';
      buttonColor = Colors.blue;
    } else if (_activeTripStage == 'in_trip') {
      buttonText = 'COMPLETE TRIP';
      buttonColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('ACTIVE RIDE IN PROGRESS', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Order #$_activeOrderId', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Stage', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(_activeTripStage.toUpperCase().replaceAll('_', ' '), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('GPS Signal', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Row(
                            children: const [
                              Icon(Icons.gps_fixed, color: Colors.greenAccent, size: 14),
                              SizedBox(width: 4),
                              Text('Active', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _advanceTripStage,
              child: Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableOrdersList() {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        if (state is DriverOrdersLoaded) {
          final orders = state.orders;
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Searching for nearby rides & deliveries...'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showIncomingOrderDialog({
                        'id': 'ORD_${DateTime.now().millisecondsSinceEpoch}',
                        'serviceType': 'ride',
                        'fare': 35.50,
                        'pickupAddress': 'King Fahd Road, Gate 4',
                        'dropoffAddress': 'King Khalid International Airport',
                      });
                    },
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Simulate Incoming Ride Request'),
                  ),
                ],
              ),
            );
          }
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.radar, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              const Text('Driver Mode Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Broadcasting live location to passenger dispatch system...'),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                onPressed: () {
                  _showIncomingOrderDialog({
                    'id': 'ORD_8892',
                    'serviceType': 'ride',
                    'fare': 28.00,
                    'pickupAddress': 'Riyadh Park Mall',
                    'dropoffAddress': 'Al Nakheel District',
                  });
                },
                icon: const Icon(Icons.add_location_alt, color: Colors.white),
                label: const Text('Simulate Incoming Ride Request', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
