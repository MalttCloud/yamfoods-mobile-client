import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_version.freezed.dart';

@freezed
sealed class AppVersion with _$AppVersion {
  const factory AppVersion({
    required String version,
    required int buildNumber,
    required bool mustBeBlocking,
     String? playstoreLink,
     String? appstoreLink,
  }) = _AppVersion;
}

