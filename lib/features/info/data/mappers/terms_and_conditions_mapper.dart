import '../../domain/entities/terms_and_conditions.dart';
import '../models/terms_and_conditions_model.dart';

extension TermsAndConditionsMapper on TermsAndConditionsModel {
  TermsAndConditions toDomain() {
    return TermsAndConditions(
      id: id,
      title: title,
      description: description,
      link: link,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
