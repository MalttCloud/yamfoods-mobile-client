import 'package:flutter/material.dart';

import '../../../../app/theme/app_sizes.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../responsive.dart';
import '../../domain/entities/branch.dart';
import 'branch_ring_selector.dart';

/// Horizontal scrollable list of branch ring selectors.
///
/// Displays all branches as circular rings that can be selected.
/// Distance is shown only when [userPosition] is non-null.
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
    return SizedBox(
      height: context.isTablet ? 240 : 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
        itemCount: branches.length,
        separatorBuilder: (_, _) => SizedBox(width: context.isTablet ? AppSizes.xxl : AppSizes.lg),
        itemBuilder: (context, index) {
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
        },
      ),
    );
  }
}
