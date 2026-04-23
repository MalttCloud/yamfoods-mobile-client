import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/promo_banner.dart';
import '../../domain/repositories/promo_banner_repository.dart';
import '../datasources/promo_banner_remote_data_source.dart';
import '../mappers/promo_banner_mapper.dart';

/// Implementation of [PromoBannerRepository] following Clean Architecture principles.
///
/// This class:
/// - Coordinates between remote data sources
/// - Maps data models to domain entities
/// - Provides a clean interface for use cases
class PromoBannerRepositoryImpl implements PromoBannerRepository {
  final PromoBannerRemoteDataSource _remoteDataSource;

  const PromoBannerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PromoBanner>>> getActivePromoBanners() async {
    final result = await _remoteDataSource.getActivePromoBanners();

    return result.fold((failure) => Left(failure), (promoBannerModels) {
      // Map to domain entities
      final domainPromoBanners = promoBannerModels
          .map((b) => b.toDomain())
          .toList();
      return Right(domainPromoBanners);
    });
  }
}
