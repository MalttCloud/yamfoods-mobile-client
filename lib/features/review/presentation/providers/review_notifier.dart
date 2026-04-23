import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_request_data.dart';
import 'review_providers.dart';
import 'review_events.dart';
import 'review_loading_providers.dart';

part 'review_notifier.g.dart';

/// Manages review list state and CRUD operations for a specific product.
///
/// **State Management:**
/// - Optimistically updates local state on success
/// - Emits UI events for success/failure
/// - Tracks loading states per operation
@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  Future<List<Review>> build(int productId) async {
    return await _load(productId);
  }

  Future<void> load(int productId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _load(productId));
  }

  Future<void> create(ReviewRequestData data) async {
    final createLoading = ref.read(reviewCreateLoadingProvider.notifier);
    createLoading.setLoading(true);

    final useCase = await ref.watch(createReviewUseCaseProvider.future);
    final result = await useCase.call(data);
    //this line exact same as below
    // final result = await useCase(data);
    //both works exactly same

    result.fold(
      (failure) {
        ref.read(reviewUiEventsProvider.notifier).emit(ReviewFailure(failure));
      },
      (created) {
        final current = state.value ?? const <Review>[];
        state = AsyncValue.data([created, ...current]);
        ref
            .read(reviewUiEventsProvider.notifier)
            .emit(ReviewCreated(created, 'Review created successfully'));
      },
    );

    createLoading.setLoading(false);
  }

  Future<void> updateReview({
    required int id,
    required ReviewRequestData data,
  }) async {
    final updating = ref.read(reviewUpdateLoadingProvider.notifier);
    updating.start(id);
    final useCase = await ref.read(updateReviewUseCaseProvider.future);
    final result = await useCase.call(id: id, data: data);

    result.fold(
      (failure) {
        ref.read(reviewUiEventsProvider.notifier).emit(ReviewFailure(failure));
      },
      (updated) {
        final list = List<Review>.from(state.value ?? const <Review>[]);
        final idx = list.indexWhere((e) => e.id == id);
        if (idx != -1) list[idx] = updated;
        state = AsyncValue.data(list);
        ref
            .read(reviewUiEventsProvider.notifier)
            .emit(ReviewUpdated(updated, 'Review updated successfully'));
      },
    );

    updating.stop(id);
  }

  Future<void> delete({required int id}) async {
    final deleting = ref.read(reviewDeleteLoadingProvider.notifier);
    deleting.start(id);

    final useCase = await ref.read(deleteReviewUseCaseProvider.future);
    final result = await useCase.call(id);

    result.fold(
      (failure) {
        ref.read(reviewUiEventsProvider.notifier).emit(ReviewFailure(failure));
      },
      (_) {
        final list = List<Review>.from(state.value ?? const <Review>[]);
        list.removeWhere((e) => e.id == id);
        state = AsyncValue.data(list);
        ref
            .read(reviewUiEventsProvider.notifier)
            .emit(ReviewDeleted(id, 'Review deleted successfully'));
      },
    );

    deleting.stop(id);
  }

  /// Throws [Failure] to be caught by [AsyncValue.guard].
  Future<List<Review>> _load(int productId) async {
    final useCase = await ref.read(getAllReviewsUseCaseProvider.future);
    final result = await useCase.call(productId);
    return result.fold((failure) {
      throw failure;
    }, (items) => items);
  }
}
