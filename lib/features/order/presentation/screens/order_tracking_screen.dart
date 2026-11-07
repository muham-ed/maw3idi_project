import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/map_view.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../injection_container.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  LatLng _driverPos = const LatLng(24.7136, 46.6753);
  double _driverBearing = 0.0;
  String _status = 'accepted';
  final _socketService = sl<SocketService>();

  final LatLng _pickupPos = const LatLng(24.7136, 46.6753);
  final LatLng _dropoffPos = const LatLng(24.7236, 46.6853);

  @override
  void initState() {
    super.initState();
    _socketService.joinOrderRoom(widget.orderId);

    _socketService.onLocationUpdate((lat, lng, bearing) {
      if (mounted) {
        setState(() {
          _driverPos = LatLng(lat, lng);
          _driverBearing = bearing;
        });
      }
    });

    _socketService.onStatusChange((status) {
      if (mounted) {
        setState(() {
          _status = status;
        });
      }
    });
  }

  String _getStatusTitle() {
    switch (_status) {
      case 'pending':
        return 'Searching for nearby drivers...';
      case 'accepted':
        return 'Driver accepted! On the way to pickup.';
      case 'driver_arrived':
        return 'Driver has arrived at pickup location!';
      case 'in_trip':
        return 'Trip in progress. On the way to destination.';
      case 'completed':
        return 'Trip completed! Thank you for riding with us.';
      case 'cancelled':
        return 'Order was cancelled.';
      default:
        return 'Driver on the way';
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case 'pending':
        return Colors.amber;
      case 'accepted':
      case 'in_trip':
        return Colors.blue;
      case 'driver_arrived':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Widget _buildTimelineStep(String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        Icon(
          isCompleted
              ? Icons.check_circle
              : (isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked),
          color: isCompleted ? Colors.green : (isCurrent ? Colors.blue : Colors.grey),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = _status == 'completed' || _status == 'cancelled';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Ride Tracking'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          OrderMapView(
            driverLocation: _driverPos,
            pickupLocation: _pickupPos,
            dropoffLocation: _dropoffPos,
            driverBearing: _driverBearing,
            rideStatus: _status,
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 5,
                            backgroundColor: _getStatusColor(),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _getStatusTitle(),
                              style: TextStyle(
                                color: _getStatusColor(),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTimelineStep('Accepted', _status != 'pending', _status == 'accepted'),
                        _buildTimelineStep('Arrived', _status == 'driver_arrived' || _status == 'in_trip' || _status == 'completed', _status == 'driver_arrived'),
                        _buildTimelineStep('In Trip', _status == 'in_trip' || _status == 'completed', _status == 'in_trip'),
                        _buildTimelineStep('Completed', _status == 'completed', _status == 'completed'),
                      ],
                    ),
                    const Divider(height: 24),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text(
                        'Mohamed Alaa (Driver)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: const Text('Toyota Camry • ABC 1234'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.green),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Calling Driver...')),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Opening Chat...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (!isFinished) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () {
                            _socketService.updateRideStatus(widget.orderId, 'cancelled');
                            setState(() {
                              _status = 'cancelled';
                            });
                          },
                          child: const Text('Cancel Ride', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
