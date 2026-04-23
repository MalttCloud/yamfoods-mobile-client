import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../domain/entities/faq.dart';
import 'faq_card.dart';

/// Renders a list of FAQs using [FaqCard].
class FaqList extends StatelessWidget {
  final List<Faq> faqs;

  const FaqList({
    super.key,
    required this.faqs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final faq in faqs) ...[
          FaqCard(faq: faq),
          const SizedBox(height: AppSizes.sm),
        ],
      ],
    );
  }
}

