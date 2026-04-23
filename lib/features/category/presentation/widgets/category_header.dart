import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/auth_guard_helper.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/cupertino_back_button.dart';
import '../../../../features/cart/presentation/widgets/animated_cart_icon.dart';
import '../../domain/entities/category.dart';

class CategoryHeader extends ConsumerWidget {
  final Category category;

  const CategoryHeader({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.sm,
        MediaQuery.of(context).padding.top + AppSizes.lg,
        AppSizes.lg,
        AppSizes.lg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoBackButton(color: AppColors.white),
          SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.h4.copyWith(color: AppColors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (category.detail.isNotEmpty) ...[
                  SizedBox(height: AppSizes.xs / 2),
                  Text(
                    category.detail,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSizes.md),
          AnimatedCartIcon(
            iconSize: AppSizes.iconSize,
            padding: EdgeInsets.all(AppSizes.sm),
            onTap: () async {
              await AuthGuardHelper.requireAuthOrShowDialog(
                context: context,
                ref: ref,
                onAuthenticated: () {
                  context.go(RouteName.cart);
                },
              );
            },
          ),
          
        ],
      ),
    );
  }
}
