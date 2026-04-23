import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../auth/domain/entities/user.dart';
import 'image_viewer.dart';

/// Profile header with avatar and name.
class ProfileHeader extends ConsumerWidget {
  final User user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = _buildImageUrl(ApiUrls.getClientImageBaseUrl());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main content (centered)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  const _VerifiedBadge(),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
          // Edit button (top right)
          Positioned(
            top: 0,
            right: AppSizes.md,
            child: IconButton(
              onPressed: () =>
                  context.push(RouteName.updateProfile, extra: user),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _buildImageUrl(String baseUrl) {
    if (user.imageUrl == null || user.imageUrl!.isEmpty) return null;
    return ImageUrlBuilder.build(baseUrl: baseUrl, imagePath: user.imageUrl!);
  }
}

/// Avatar with glow effect, Hero animation, and tap to view full screen.
class _Avatar extends StatelessWidget {
  final String? imageUrl;

  const _Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final heroTag = imageUrl ?? 'profile_avatar';

    return GestureDetector(
      onTap: imageUrl != null ? () => _openImageViewer(context) : null,
      child: Hero(
        tag: heroTag,
        child: Container(
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
        ),
      ),
    );
  }

  void _openImageViewer(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ImageViewer(imageUrl: imageUrl!)));
  }

  Widget _buildContent() {
    if (imageUrl == null) return _placeholder();
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      placeholder: (_, _) => _placeholder(),
      errorWidget: (_, _, _) => _placeholder(),
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
