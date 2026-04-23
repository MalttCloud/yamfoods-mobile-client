okay let me give you the above related files written by junior dev from another project. i have no idea weather his configuration are match with what we want since we follow industry level  professional best practice way what expert do in flutter and dio

here what he did and we're gonna analyze and judge his work


import 'package:get_it/get_it.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:logger/logger.dart';

bool isTokenExpired(String token) {
  final Logger logger = GetIt.instance<Logger>();
  Duration expiryBuffer = const Duration(minutes: 5);
  try {
    final decodedToken = Jwt.parseJwt(token);
    final exp = decodedToken['exp'] as int?;
    if (exp == null) return true;
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final bufferedExpiry = expiryDate.subtract(expiryBuffer);
    return DateTime.now().isAfter(bufferedExpiry);
  } catch (e) {
    logger.e('Token decode error: $e');
    return true;
  }
}
