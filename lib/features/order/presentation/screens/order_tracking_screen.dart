import 'package:flutter/material.dart';

import '../widgets/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String _status = 'On the way';
  final _socketService = sl<SocketService>();

  @override
  void initState() {
    super.initState();
    _socketService.joinOrderRoom(widget.orderId);
    _socketService.onLocationUpdate((lat, lng) {
      setState(() {
        _driverPos = LatLng(lat, lng);
      });
    });
    _socketService.onStatusChange((status) {
      setState(() {
        _status = status;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Stack(
        children: [
          OrderMapView(
            driverLocation: _driverPos,
            deliveryLocation: const LatLng(24.7236, 46.6853),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text('Ahmed (Driver)'),
                      subtitle: Text('Arriving soon'),
                      trailing: Icon(Icons.phone, color: Colors.green),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status: $_status'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Cancel Order', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
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
