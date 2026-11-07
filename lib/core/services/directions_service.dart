import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class DirectionResult {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMins;

  DirectionResult({
    required this.points,
    required this.distanceKm,
    required this.durationMins,
  });
}

class DirectionsService {
  final Dio _dio = Dio();

  /// Fetches actual road points between origin and destination using OSRM Routing Engine (Open Source)
  /// Fallbacks to interpolated curves if offline
  Future<DirectionResult> getRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng>? waypoints,
  }) async {
    try {
      final String waypointsString = waypoints != null && waypoints.isNotEmpty
          ? waypoints.map((p) => '${p.longitude},${p.latitude}').join(';') + ';'
          : '';

      final String url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '$waypointsString'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      final response = await _dio.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data['routes'] != null && (response.data['routes'] as List).isNotEmpty) {
        final route = response.data['routes'][0];
        final coordinates = route['geometry']['coordinates'] as List;
        final double distanceMeters = (route['distance'] as num).toDouble();
        final double durationSeconds = (route['duration'] as num).toDouble();

        final List<LatLng> points = coordinates.map((coord) {
          final List item = coord as List;
          return LatLng((item[1] as num).toDouble(), (item[0] as num).toDouble());
        }).toList();

        return DirectionResult(
          points: points,
          distanceKm: double.parse((distanceMeters / 1000).toStringAsFixed(2)),
          durationMins: (durationSeconds / 60).round(),
        );
      }
    } catch (e) {
      // Fallback interpolation if offline or OSRM unavailable
    }

    return _generateInterpolatedRoadPath(origin, destination);
  }

  /// Calculates geometric bearing (heading angle in degrees 0..360) between two coordinates
  static double calculateBearing(LatLng start, LatLng end) {
    final double startLat = _toRadians(start.latitude);
    final double startLng = _toRadians(start.longitude);
    final double endLat = _toRadians(end.latitude);
    final double endLng = _toRadians(end.longitude);

    final double dLng = endLng - startLng;
    final double y = sin(dLng) * cos(endLat);
    final double x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLng);

    final double brng = atan2(y, x);
    return (_toDegrees(brng) + 360) % 360;
  }

  /// Calculates straight-line distance in kilometers (Haversine formula)
  static double calculateHaversineDistance(LatLng start, LatLng end) {
    const double r = 6371; // Earth radius in km
    final double dLat = _toRadians(end.latitude - start.latitude);
    final double dLng = _toRadians(end.longitude - start.longitude);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) * cos(_toRadians(end.latitude)) * sin(dLng / 2) * sin(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return double.parse((r * c).toStringAsFixed(2));
  }

  static DirectionResult _generateInterpolatedRoadPath(LatLng start, LatLng end) {
    final List<LatLng> path = [start];
    const int steps = 10;
    final double dLat = (end.latitude - start.latitude) / steps;
    final double dLng = (end.longitude - start.longitude) / steps;

    for (int i = 1; i < steps; i++) {
      final double offset = (i % 2 == 0 ? 0.0005 : -0.0005);
      path.add(LatLng(
        start.latitude + (dLat * i) + offset,
        start.longitude + (dLng * i) - offset,
      ));
    }
    path.add(end);

    final double dist = calculateHaversineDistance(start, end);
    return DirectionResult(
      points: path,
      distanceKm: dist,
      durationMins: (dist * 2.5).round().clamp(1, 120),
    );
  }

  static double _toRadians(double degree) => degree * (pi / 180.0);
  static double _toDegrees(double rad) => rad * (180.0 / pi);
}
