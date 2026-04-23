import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/promo_banner.dart';
import '../repositories/promo_banner_repository.dart';

/// Use case for getting all active promo banners.
///
/// This encapsulates the business logic for fetching active promo banners.
/// It delegates to the repository which handles remote fetching.
class GetActivePromoBannersUsecase {
  final PromoBannerRepository _repository;

  const GetActivePromoBannersUsecase(this._repository);

  /// Executes the use case to get all active promo banners.
  ///
  /// Returns [Either] containing:
  /// - [Right] with list of promo banners on success
  /// - [Left] with [Failure] on error
  Future<Either<Failure, List<PromoBanner>>> call() async {
    return await _repository.getActivePromoBanners();
  }
}

