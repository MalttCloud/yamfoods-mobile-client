import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/review.dart';
import '../../../../core/errors/failure.dart';

part 'review_events.g.dart';

sealed class ReviewUiEvent {}

class ReviewCreated extends ReviewUiEvent {
  final Review entity;
  final String message;
  ReviewCreated(this.entity, this.message);
}

class ReviewUpdated extends ReviewUiEvent {
  final Review entity;
  final String message;
  ReviewUpdated(this.entity, this.message);
}

class ReviewDeleted extends ReviewUiEvent {
  final int id;
  final String message;
  ReviewDeleted(this.id, this.message);
}

class ReviewFailure extends ReviewUiEvent {
  final Failure failure;
  ReviewFailure(this.failure);
}

@riverpod
class ReviewUiEvents extends _$ReviewUiEvents {
  @override
  ReviewUiEvent? build() {
    return null;
  }

  void emit(ReviewUiEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}
