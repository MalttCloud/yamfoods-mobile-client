import '../../domain/entities/help_support.dart';
import '../models/help_support_model.dart';

extension HelpSupportMapper on HelpSupportModel {
  HelpSupport toDomain() {
    return HelpSupport(
      id: id,
      email: email,
      phone1: phone1,
      phone2: phone2,
      telegram: telegram,
      instagram: instagram,
      facebook: facebook,
      tiktok: tiktok,
      website: website,
      address: address,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
