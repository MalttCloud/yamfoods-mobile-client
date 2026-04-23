import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/achievement_point.dart';
import '../../domain/entities/achievement_transaction.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../datasources/achievement_remote_data_source.dart';
import '../mappers/achievement_mapper.dart';

/// Maps data models to domain entities and coordinates data sources.
///
/// Errors from data sources are propagated without transformation.
class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementRemoteDataSource _remoteDataSource;

  const AchievementRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AchievementPoint>> getAchievementPoint() async {
    final result = await _remoteDataSource.getAchievementPoint();

    return result.fold(
      (failure) => Left(failure),
      (pointModel) => Right(pointModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, Unit>> sendPoint({
    required int point,
    required String phone,
  }) async {
    final result = await _remoteDataSource.sendPoint(
      point: point,
      phone: phone,
    );

    return result.fold((failure) => Left(failure), (_) => const Right(unit));
  }

  @override
  Future<Either<Failure, List<AchievementTransaction>>>
  getAchievementHistory() async {
    final result = await _remoteDataSource.getAchievementHistory();

    return result.fold((failure) => Left(failure), (historyModel) {
      final domainTransactions = historyModel.transaction
          .map((t) => t.toDomain())
          .toList();
      return Right(domainTransactions);
    });
  }
}
