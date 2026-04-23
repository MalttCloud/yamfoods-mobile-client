import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/branch_model.dart';

/// Remote data source interface for branch operations.
///
/// This defines the contract for fetching branch data from the backend.
/// All methods return [Either<Failure, T>] for proper error handling.
abstract class BranchRemoteDataSource {
  /// Gets all branches from the remote API.
  ///
  /// Returns [Either] containing:
  /// - [Right] with list of branch models on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, List<BranchModel>>> getAllBranches();
}
