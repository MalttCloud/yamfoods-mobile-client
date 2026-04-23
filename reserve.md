import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../auth/domain/entities/user.dart';

/// Profile header with avatar and name.
class ProfileHeader extends ConsumerWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envConfig = ref.watch(envConfigProvider);
    final imageUrl = _buildImageUrl(envConfig.baseUrl);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.65, 0.8, 0.9, 0.95, 0.98, 0.995, 1.0],
          colors: [
            AppColors.primary,
            _blendColors(AppColors.primary, AppColors.background, 0.2),
            _blendColors(AppColors.primary, AppColors.background, 0.45),
            _blendColors(AppColors.primary, AppColors.background, 0.65),
            _blendColors(AppColors.primary, AppColors.background, 0.82),
            _blendColors(AppColors.primary, AppColors.background, 0.92),
            _blendColors(AppColors.primary, AppColors.background, 0.97),
            _blendColors(AppColors.primary, AppColors.background, 0.99),
            AppColors.background,
          ],
        ),
        
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            _Avatar(imageUrl: imageUrl)
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut)
                .fadeIn(),
            const SizedBox(height: AppSizes.md),
            // Name with badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user.name,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                const _VerifiedBadge(),
              ],
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  String? _buildImageUrl(String baseUrl) {
    if (user.imageUrl == null || user.imageUrl!.isEmpty) return null;
    return ImageUrlBuilder.build(baseUrl: baseUrl, imagePath: user.imageUrl!);
  }

  /// Blends two colors together based on a ratio.
  /// [ratio] should be between 0.0 (full color1) and 1.0 (full color2).
  static Color _blendColors(Color color1, Color color2, double ratio) {
    final clampedRatio = ratio.clamp(0.0, 1.0);
    return Color.fromRGBO(
      (((color1.r * (1 - clampedRatio)) + (color2.r * clampedRatio)) * 255.0)
          .round()
          .clamp(0, 255),
      (((color1.g * (1 - clampedRatio)) + (color2.g * clampedRatio)) * 255.0)
          .round()
          .clamp(0, 255),
      (((color1.b * (1 - clampedRatio)) + (color2.b * clampedRatio)) * 255.0)
          .round()
          .clamp(0, 255),
      1.0,
    );
  }
}

/// Avatar with glow effect and cached network image.
class _Avatar extends StatelessWidget {
  final String? imageUrl;

  const _Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 3),
        ),
        child: ClipOval(child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    if (imageUrl == null) return _placeholder();
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, __) => _loading(),
      errorWidget: (_, __, ___) => _placeholder(),
    );
  }

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.3),
      child: const Icon(Icons.person_rounded, size: 48, color: AppColors.white),
    );
  }
}

/// Modern verified badge icon (Instagram-style).
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 4,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: const Icon(
        Icons.verified_rounded,
        size: 16,
        color: AppColors.white,
      ),
    );
  }
}




good design

/// Placeholder for transaction history (to be implemented later).
class _TransactionHistoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      padding: const EdgeInsets.all(AppSizes.xxl),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_outlined,
            size: 48,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Transaction History',
            style: TextStyle(
              fontFamily: 'Cera Pro',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Coming soon',
            style: TextStyle(
              fontFamily: 'Cera Pro',
              fontSize: 14,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
