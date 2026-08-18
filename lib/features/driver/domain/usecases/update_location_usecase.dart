import 'package:geolocator/geolocator.dart';
import '../repositories/driver_repository.dart';

class UpdateLocationUseCase {
  final DriverRepository repository;
  const UpdateLocationUseCase(this.repository);

  Future<void> call(Position position) => repository.updateLocation(position);
}
