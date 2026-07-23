import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/info_repository.dart';

class RecordDauUsecase {
  final InfoRepository _repository;

  const RecordDauUsecase(this._repository);

  Future<Either<Failure, void>> call() async {
    return _repository.recordDau();
  }
}
