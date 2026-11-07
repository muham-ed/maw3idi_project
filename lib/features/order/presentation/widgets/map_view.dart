import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/directions_service.dart';

class OrderMapView extends StatefulWidget {
  final LatLng driverLocation;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final double driverBearing;
  final String rideStatus;

  const OrderMapView({
    super.key,
    required this.driverLocation,
    this.pickupLocation = const LatLng(24.7136, 46.6753),
    this.dropoffLocation = const LatLng(24.7236, 46.6853),
    this.driverBearing = 0.0,
    this.rideStatus = 'accepted',
  });

  @override
  State<OrderMapView> createState() => _OrderMapViewState();
}

class _OrderMapViewState extends State<OrderMapView> {
  GoogleMapController? _controller;
  final DirectionsService _directionsService = DirectionsService();

  List<LatLng> _routePoints = [];
  double _distanceKm = 0.0;
  int _durationMins = 0;
  bool _isLoadingRoute = true;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  @override
  void didUpdateWidget(covariant OrderMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverLocation != widget.driverLocation ||
        oldWidget.rideStatus != widget.rideStatus) {
      _loadRoute();
      _reframeCamera();
    }
  }

  Future<void> _loadRoute() async {
    final bool headingToPickup = widget.rideStatus == 'accepted' || widget.rideStatus == 'pending';
    final LatLng targetDestination = headingToPickup ? widget.pickupLocation : widget.dropoffLocation;

    final result = await _directionsService.getRoute(
      origin: widget.driverLocation,
      destination: targetDestination,
    );

    if (mounted) {
      setState(() {
        _routePoints = result.points;
        _distanceKm = result.distanceKm;
        _durationMins = result.durationMins;
        _isLoadingRoute = false;
      });
      _reframeCamera();
    }
  }

  void _reframeCamera() {
    if (_controller == null) return;

    final List<LatLng> activePoints = [
      widget.driverLocation,
      widget.pickupLocation,
      widget.dropoffLocation,
    ];

    double minLat = activePoints.first.latitude;
    double maxLat = activePoints.first.latitude;
    double minLng = activePoints.first.longitude;
    double maxLng = activePoints.first.longitude;

    for (var point in activePoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - 0.005, minLng - 0.005),
      northeast: LatLng(maxLat + 0.005, maxLng + 0.005),
    );

    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.driverLocation,
            zoom: 14,
          ),
          myLocationEnabled: false,
          compassEnabled: true,
          zoomControlsEnabled: false,
          markers: {
            Marker(
              markerId: const MarkerId('driver'),
              position: widget.driverLocation,
              rotation: widget.driverBearing,
              anchor: const Offset(0.5, 0.5),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              infoWindow: const InfoWindow(title: 'Driver (Live)'),
            ),
            Marker(
              markerId: const MarkerId('pickup'),
              position: widget.pickupLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              infoWindow: const InfoWindow(title: 'Pickup Location'),
            ),
            Marker(
              markerId: const MarkerId('dropoff'),
              position: widget.dropoffLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: const InfoWindow(title: 'Destination'),
            ),
          },
          polylines: {
            if (_routePoints.isNotEmpty)
              Polyline(
                polylineId: const PolylineId('active_route'),
                points: _routePoints,
                color: const Color(0xFF0066FF),
                width: 6,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
              ),
          },
          onMapCreated: (controller) {
            _controller = controller;
            _reframeCamera();
          },
        ),
        if (!_isLoadingRoute)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$_durationMins min away',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  Container(height: 16, width: 1, color: Colors.white30),
                  Row(
                    children: [
                      const Icon(Icons.add_road, color: Colors.blueAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$_distanceKm km',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
