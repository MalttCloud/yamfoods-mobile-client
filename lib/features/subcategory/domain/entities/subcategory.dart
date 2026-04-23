import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory.freezed.dart';

@freezed
sealed class Subcategory with _$Subcategory {
  const factory Subcategory({
    required int id,
    required int categoryId,
    required String name,
    String? detail,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Subcategory;
}
