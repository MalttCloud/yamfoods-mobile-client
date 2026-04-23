import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/faq.dart';
import '../repositories/info_repository.dart';

class GetFaqsUsecase {
  final InfoRepository _repository;

  const GetFaqsUsecase(this._repository);

  Future<Either<Failure, List<Faq>>> call() async {
    return await _repository.getFaqs();
  }
}
