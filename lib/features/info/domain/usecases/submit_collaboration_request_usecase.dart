import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/info_repository.dart';

class SubmitCollaborationRequestUsecase {
  final InfoRepository _repository;

  const SubmitCollaborationRequestUsecase(this._repository);

  Future<Either<Failure, void>> call({
    required String name,
    required String phone,
    String? email,
    String? organization,
    String? website,
    required String title,
    required String proposal,
  }) async {
    return _repository.submitCollaborationRequest(
      name: name,
      phone: phone,
      email: email,
      organization: organization,
      website: website,
      title: title,
      proposal: proposal,
    );
  }
}
