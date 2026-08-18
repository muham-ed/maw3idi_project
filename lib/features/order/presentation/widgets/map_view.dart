import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapView extends StatefulWidget {
  final LatLng driverLocation;
  final LatLng deliveryLocation;

  const OrderMapView({
    super.key,
    required this.driverLocation,
    required this.deliveryLocation,
  });

  @override
  State<OrderMapView> createState() => _OrderMapViewState();
}

class _OrderMapViewState extends State<OrderMapView> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.deliveryLocation,
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('driver'),
          position: widget.driverLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Driver'),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.deliveryLocation,
          infoWindow: const InfoWindow(title: 'Delivery Location'),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId('route'),
          points: [widget.driverLocation, widget.deliveryLocation],
          color: Colors.blue,
          width: 5,
        ),
      },
      onMapCreated: (controller) => _controller = controller,
    );
  }
}
