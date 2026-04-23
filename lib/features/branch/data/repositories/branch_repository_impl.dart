import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branch_repository.dart';
import '../datasources/branch_remote_data_source.dart';
import '../mappers/branch_mapper.dart';

/// Implementation of [BranchRepository] following Clean Architecture principles.
///
/// Fetches branch data from the remote API only (no local cache).
class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource _remoteDataSource;

  const BranchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Branch>>> getAllBranches() async {
    final result = await _remoteDataSource.getAllBranches();
    return result.fold(
      (failure) => Left(failure),
      (branchModels) {
        final domainBranches =
            branchModels.map((b) => b.toDomain()).toList();
        return Right(domainBranches);
      },
    );
  }
}
