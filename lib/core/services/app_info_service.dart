import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_service.g.dart';

class AppInfo {
  final String version;
  final int buildNumber;

  const AppInfo({
    required this.version,
    required this.buildNumber,
  });
}

class AppInfoService {
  AppInfo? _cached;

  Future<AppInfo> getAppInfo() async {
    final cached = _cached;
    if (cached != null) return cached;

    final info = await PackageInfo.fromPlatform();
    final buildNumber = int.tryParse(info.buildNumber) ?? 1;

    final result = AppInfo(
      version: info.version,
      buildNumber: buildNumber,
    );

    _cached = result;
    return result;
  }
}

@Riverpod(keepAlive: true)
AppInfoService appInfoService(Ref ref) {
  return AppInfoService();
}

@Riverpod(keepAlive: true)
Future<AppInfo> appInfo(Ref ref) async {
  final service = ref.watch(appInfoServiceProvider);
  return service.getAppInfo();
}

