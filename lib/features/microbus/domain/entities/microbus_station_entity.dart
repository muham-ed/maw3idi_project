import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MicrobusStationEntity extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final LatLng location;
  final double baseFareFromStart;

  const MicrobusStationEntity({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.location,
    required this.baseFareFromStart,
  });

  @override
  List<Object?> get props => [id, nameArabic, nameEnglish, location, baseFareFromStart];
}

class MicrobusRouteEntity extends Equatable {
  final String id;
  final String routeName;
  final List<MicrobusStationEntity> stations;
  final double officialFarePerStation;

  const MicrobusRouteEntity({
    required this.id,
    required this.routeName,
    required this.stations,
    required this.officialFarePerStation,
  });

  double calculateExactFare(String fromStationId, String toStationId) {
    final fromIndex = stations.indexWhere((s) => s.id == fromStationId);
    final toIndex = stations.indexWhere((s) => s.id == toStationId);

    if (fromIndex == -1 || toIndex == -1) return 10.0;
    final int stationDistance = (toIndex - fromIndex).abs();
    return (stationDistance * officialFarePerStation).clamp(5.0, 30.0);
  }

  @override
  List<Object?> get props => [id, routeName, stations, officialFarePerStation];
}
