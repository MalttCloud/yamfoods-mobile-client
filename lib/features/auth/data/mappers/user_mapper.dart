import '../../domain/entities/user.dart';
import '../models/user_model.dart';

extension UserModelMapper on UserModel {
  User toDomain() => User(
    id: id,
    imageUrl: imageUrl,
    name: name,
    phone: phone,
    role: role,
    email: email,
    phoneVerified: phoneVerified == 1 ? true : false,
    googleId: googleId,
    provider: provider,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
