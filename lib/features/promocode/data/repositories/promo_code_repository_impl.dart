import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/promo_code.dart';
import '../../domain/entities/promo_code_verification_result.dart';
import '../../domain/repositories/promo_code_repository.dart';
import '../datasources/promo_code_remote_data_source.dart';
import '../mappers/promo_code_mapper.dart';

/// Maps data models to domain entities and coordinates data sources.
///
/// Errors from data sources are propagated without transformation.
class PromoCodeRepositoryImpl implements PromoCodeRepository {
  final PromoCodeRemoteDataSource _remoteDataSource;

  const PromoCodeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PromoCodeVerificationResult>> verifyPromoCode({
    required String code,
    required double orderAmount,
  }) async {
    final result = await _remoteDataSource.verifyPromoCode(
      code: code,
      orderAmount: orderAmount,
    );

    return result.fold(
      (failure) => Left(failure),
      (resultModel) => Right(resultModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, List<PromoCode>>> getPromoCodes() async {
    final result = await _remoteDataSource.getPromoCodes();

    return result.fold((failure) => Left(failure), (promoCodeModels) {
      final domainPromoCodes = promoCodeModels
          .map((p) => p.toDomain())
          .toList();
      return Right(domainPromoCodes);
    });
  }
}
