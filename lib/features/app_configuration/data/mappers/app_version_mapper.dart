import '../../domain/entities/app_version.dart';
import '../models/app_version_model.dart';

extension AppVersionMapper on AppVersionModel {
  AppVersion toDomain() {
    return AppVersion(
      version: version,
      buildNumber: buildNumber,
      mustBeBlocking: mustBeBlocking,
      playstoreLink: playstoreLink,
      appstoreLink: appstoreLink,
    );
  }
}

