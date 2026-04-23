import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Shared skeleton effect for light/neutral backgrounds (product card, promo banner).
const ShimmerEffect kAppSkeletonEffect = ShimmerEffect(
  baseColor: Color.fromARGB(255, 230, 230, 230),
  highlightColor: Color.fromARGB(255, 245, 245, 245),
);

/// Skeleton effect for dark/gradient backgrounds (e.g. category chips on primary).
const ShimmerEffect kAppSkeletonEffectOnDark = ShimmerEffect(
  baseColor: Color.fromARGB(64, 255, 255, 255),
  highlightColor: Color.fromARGB(128, 255, 255, 255),
);

/// Wrapper around [Skeletonizer.zone] so all skeletons use the same effect config.
///
/// Use [effect] for light backgrounds (default). Use [kAppSkeletonEffectOnDark]
/// for content on primary/gradient (e.g. category chips).
class AppSkeletonizerZone extends StatelessWidget {
  const AppSkeletonizerZone({
    super.key,
    required this.child,
    this.enabled = true,
    this.effect,
  });

  final Widget child;
  final bool enabled;
  final ShimmerEffect? effect;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      enabled: enabled,
      effect: effect ?? kAppSkeletonEffect,
      child: child,
    );
  }
}
