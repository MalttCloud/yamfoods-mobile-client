import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
sealed class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required String detail,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;
}
