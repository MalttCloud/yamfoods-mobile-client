import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version_model.freezed.dart';
part 'app_version_model.g.dart';

@freezed
sealed class AppVersionModel with _$AppVersionModel {
  const AppVersionModel._();

  const factory AppVersionModel({
    required String version,
    required int buildNumber,
    required bool mustBeBlocking,
     String? playstoreLink,
    String? appstoreLink,
  }) = _AppVersionModel;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);
}

