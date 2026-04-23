import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/promo_banner.dart';

/// Repository interface for promo banner operations.
///
/// This defines the contract for fetching promo banner data from various sources
/// (remote API, local cache, etc.). All methods return [Either<Failure, T>]
/// for proper error handling.
abstract class PromoBannerRepository {
  /// Gets all active promo banners.
  ///
  /// Returns [Either] containing:
  /// - [Right] with list of promo banners on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, List<PromoBanner>>> getActivePromoBanners();
}
