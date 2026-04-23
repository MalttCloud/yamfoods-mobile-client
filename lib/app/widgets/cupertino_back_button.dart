import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';

class CupertinoBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? iconSize;

  const CupertinoBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => context.pop(),
      icon: Icon(
        CupertinoIcons.back,
        color: color ?? AppColors.txtPrimary,
        size: iconSize ?? AppSizes.iconSize,
      ),
    );
  }
}
