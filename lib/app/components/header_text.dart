import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

Text headerText(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.txtPrimary,
      fontSize: 20
    ),
  );
}
