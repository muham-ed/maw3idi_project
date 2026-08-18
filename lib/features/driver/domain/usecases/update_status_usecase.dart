import 'package:dartz/dartz.dart';
import '../repositories/driver_repository.dart';

class UpdateStatusUseCase {
  final DriverRepository repository;
  const UpdateStatusUseCase(this.repository);

  Future<Either<String, void>> call(bool isOnline) => repository.updateStatus(isOnline);
}
