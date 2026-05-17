import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../responsive.dart';
import '../../domain/entities/achievement_point.dart';
import 'send_point_bottom_sheet.dart';

/// Premium virtual wallet card with brand-aligned premium aesthetic.
///
/// Features:
/// - Rich gradient background using app branding colors (warm browns)
/// - Large, bold points balance as hero element
/// - Subtle elevation with soft shadow
/// - Light grain texture overlay
/// - Premium typography and spacing
class AchievementWalletCard extends StatelessWidget {
  final AchievementPoint achievementPoint;

  const AchievementWalletCard({super.key, required this.achievementPoint});

  @override
  Widget build(BuildContext context) {
    final gradientColors = [
      const Color(0xFF5A2F08),
      Color.lerp(AppColors.primary, Colors.black, 0.15)!,
      Color.lerp(AppColors.primary, Colors.black, 0.35)!,
      Color.lerp(AppColors.primary, Colors.black, 0.55)!,
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        height: context.isTablet ? 200 : 180,
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: gradientColors,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: gradientColors,
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),

              // Grain texture overlay
              _GrainOverlay(),

              // Subtle light reflection/divider
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top section: Icon and brand
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Wallet icon
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        // Subtle brand mark (optional - can be replaced with app logo)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Main content: Wallet balance
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Wallet Balance',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              achievementPoint.point.toDouble().toStringAsFixed(
                                2,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Cera Pro',
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Text(
                                'Pts',
                                style: TextStyle(
                                  fontFamily: 'Cera Pro',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Action area: Send button
                    Align(
                      alignment: Alignment.centerRight,
                      child: _SendButton(
                        onTap: () => _showSendPointBottomSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Send button with premium styling.
class _SendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.send_rounded, color: Colors.white, size: 14),
            const SizedBox(width: 5),
            Text(
              'Send',
              style: AppTextStyles.buttonMedium.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSendPointBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const SendPointBottomSheet(),
  );
}

/// Grain texture overlay for premium feel.
class _GrainOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GrainPainter(), size: Size.infinite);
  }
}

/// Painter for subtle grain texture.
class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    // Create a subtle grain pattern
    for (int i = 0; i < 200; i++) {
      final x = (i * 23.7) % size.width;
      final y = (i * 37.3) % size.height;
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
