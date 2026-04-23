import '../../domain/entities/privacy_policy.dart';
import '../models/privacy_policy_model.dart';

extension PrivacyPolicyMapper on PrivacyPolicyModel {
  PrivacyPolicy toDomain() {
    return PrivacyPolicy(
      id: id,
      title: title,
      description: description,
      link: link,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
