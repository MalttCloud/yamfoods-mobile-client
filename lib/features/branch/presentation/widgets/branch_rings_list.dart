import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../responsive.dart';
import '../../domain/entities/branch.dart';
import 'branch_ring_selector.dart';

/// Horizontal list of branch ring selectors.
///
/// - Centers the rings when they all fit on screen.
/// - Falls back to horizontal scrolling when they don't.
class BranchRingsList extends StatelessWidget {
  final List<Branch> branches;
  final int selectedIndex;
  final ({double lat, double lng})? userPosition;
  final ValueChanged<int> onBranchSelected;

  const BranchRingsList({
    super.key,
    required this.branches,
    required this.selectedIndex,
    this.userPosition,
    required this.onBranchSelected,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.isTablet ? AppSizes.xl : AppSizes.xxxl;

    final spacing = context.isTablet ? AppSizes.xxl : AppSizes.lg;

    final children = List.generate(branches.length, (index) {
      final branch = branches[index];

      final formattedDistance = userPosition != null
          ? DistanceCalculator.calculateDistanceInMeters(
              userPosition!,
              branch.location,
            )
          : null;

      return BranchRingSelector(
        name: branch.name,
        distance: formattedDistance,
        isSelected: index == selectedIndex,
        onTap: () => onBranchSelected(index),
      );
    });

    return SizedBox(
      height: context.isTablet ? 240 : 140,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Approximate width occupied by each ring.
          final ringWidth = context.isTablet ? 200.0 : 100.0;

          final totalWidth =
              branches.length * ringWidth +
              (branches.length - 1) * spacing +
              horizontalPadding * 2;

          // Everything fits -> center it.
          if (totalWidth <= constraints.maxWidth) {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i != children.length - 1) SizedBox(width: spacing),
                  ],
                ],
              ),
            );
          }

          // Doesn't fit -> make it scrollable.
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: branches.length,
            separatorBuilder: (_, _) => SizedBox(width: spacing),
            itemBuilder: (_, index) => children[index],
          );
        },
      ),
    );
  }
}
