import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_request_data.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';
import '../mappers/review_mapper.dart';

/// Maps data models to domain entities and coordinates data sources.
///
/// Errors from data sources are propagated without transformation.
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  const ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Review>>> getAllReviews(int productId) async {
    final result = await _remoteDataSource.getAllReviews(productId);

    return result.fold((failure) => Left(failure), (reviewModels) {
      final domainReviews = reviewModels.map((r) => r.toDomain()).toList();
      return Right(domainReviews);
    });
  }

  @override
  Future<Either<Failure, Review>> createReview(ReviewRequestData data) async {
    final result = await _remoteDataSource.createReview(data);

    return result.fold(
      (failure) => Left(failure),
      (reviewModel) => Right(reviewModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, Review>> updateReview({
    required int id,
    required ReviewRequestData data,
  }) async {
    final result = await _remoteDataSource.updateReview(id: id, data: data);

    return result.fold(
      (failure) => Left(failure),
      (reviewModel) => Right(reviewModel.toDomain()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteReview(int id) async {
    return await _remoteDataSource.deleteReview(id);
  }
}
