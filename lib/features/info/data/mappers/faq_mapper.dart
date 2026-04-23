import '../../domain/entities/faq.dart';
import '../models/faq_model.dart';

extension FaqMapper on FaqModel {
  Faq toDomain() {
    return Faq(
      id: id,
      question: question,
      answer: answer,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
