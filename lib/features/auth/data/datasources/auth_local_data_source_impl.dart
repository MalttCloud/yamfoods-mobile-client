import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._storage, this._prefs);

  @override
  Future<void> saveTokens(AuthToken tokens) async {
    try {
      await _storage.write(key: 'access_token', value: tokens.accessToken);
      await _storage.write(key: 'refresh_token', value: tokens.refreshToken);
    } catch (e) {
      throw Failure.cache(message: 'Failed to save tokens: ${e.toString()}');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: 'access_token');
    } catch (e) {
      throw Failure.cache(
        message: 'Failed to read access token: ${e.toString()}',
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: 'refresh_token');
    } catch (e) {
      throw Failure.cache(
        message: 'Failed to read refresh token: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
    } catch (e) {
      throw Failure.cache(message: 'Failed to clear tokens: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      final userMap = {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "phone": user.phone,
        "role": user.role,
        "provider": user.provider,
        "imageUrl": user.imageUrl,
        "googleId": user.googleId,
        "phoneVerified": user.phoneVerified,
        "referralCode": user.referralCode,
        "createdAt": user.createdAt.toIso8601String(),
        "updatedAt": user.updatedAt.toIso8601String(),
      };

      final userJson = jsonEncode(userMap);
      await _prefs.setString("user_data", userJson);
    } catch (e) {
      throw Failure.cache(message: 'Failed to save user: ${e.toString()}');
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      final jsonString = _prefs.getString("user_data");
      if (jsonString == null) {
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Handle phoneVerified: can be bool (new format) or int (old format)
      final phoneVerifiedValue = data["phoneVerified"];
      final phoneVerified = phoneVerifiedValue is bool
          ? phoneVerifiedValue
          : (phoneVerifiedValue is int ? phoneVerifiedValue == 1 : false);

      return User(
        id: data["id"],
        name: data["name"],
        email: data["email"],
        phone: data["phone"],
        role: data["role"],
        provider: data["provider"],
        imageUrl: data["imageUrl"],
        googleId: data["googleId"],
        phoneVerified: phoneVerified,
        referralCode: data["referralCode"] as String?,
        createdAt: DateTime.parse(data["createdAt"]),
        updatedAt: DateTime.parse(data["updatedAt"]),
      );
    } catch (e) {
      // Return null on any error (corrupted data, parsing error, etc.)
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _prefs.remove("user_data");
    } catch (e) {
      throw Failure.cache(message: 'Failed to clear user: ${e.toString()}');
    }
  }
}
