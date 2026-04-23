import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/help_support.dart';
import '../repositories/info_repository.dart';

class GetHelpSupportUsecase {
  final InfoRepository _repository;

  const GetHelpSupportUsecase(this._repository);

  Future<Either<Failure, HelpSupport>> call() async {
    return await _repository.getHelpSupport();
  }
}
