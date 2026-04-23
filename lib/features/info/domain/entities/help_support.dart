import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_support.freezed.dart';

@freezed
sealed class HelpSupport with _$HelpSupport {
  const factory HelpSupport({
    required int id,
    required String email,
    required String phone1,
    String? phone2,
    String? telegram,
    String? instagram,
    String? facebook,
    String? tiktok,
    String? website,
    required String address,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HelpSupport;
}
