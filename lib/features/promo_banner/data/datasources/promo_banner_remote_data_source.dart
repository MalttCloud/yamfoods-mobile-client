import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/promo_banner_model.dart';

/// Remote data source interface for promo banner operations.
///
/// This defines the contract for fetching promo banner data from the backend.
/// All methods return [Either<Failure, T>] for proper error handling.
abstract class PromoBannerRemoteDataSource {
  /// Gets all active promo banners from the remote API.
  ///
  /// Returns [Either] containing:
  /// - [Right] with list of promo banner models on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, List<PromoBannerModel>>> getActivePromoBanners();
}
