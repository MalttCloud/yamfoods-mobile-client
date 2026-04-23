import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/branch.dart';
import '../repositories/branch_repository.dart';

/// Use case for getting all branches.
///
/// This encapsulates the business logic for fetching branches.
/// It delegates to the repository which handles caching and remote fetching.
class GetAllBranchesUsecase {
  final BranchRepository _repository;

  const GetAllBranchesUsecase(this._repository);

  /// Executes the use case to get all branches.
  ///
  /// Returns [Either] containing:
  /// - [Right] with list of branches on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, List<Branch>>> call() async {
    return await _repository.getAllBranches();
  }
}
