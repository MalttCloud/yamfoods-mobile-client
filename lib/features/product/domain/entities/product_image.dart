import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image.freezed.dart';

@freezed
sealed class ProductImage with _$ProductImage {
  const factory ProductImage({required String url, required bool isMain}) =
      _ProductImage;
}
