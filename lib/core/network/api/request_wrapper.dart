import 'package:uuid/uuid.dart';
import '../../constants/app_constants.dart';

class RequestWrapper {
  static Map<String, dynamic> wrap(
    Map<String, dynamic> data, {
    String? requestId,
  }) {
    return {
      'meta': {
        'request_id': requestId ?? const Uuid().v4(),
        'client': AppConstants.client,
        'version': AppConstants.version,
      },
      'data': data,
    };
  }

}
