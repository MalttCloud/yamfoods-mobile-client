import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/components/empty_state.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../app/components/skeleton/branch_selection_skeleton.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/permissions/location/location_gps_guard_perscreen.dart';
import '../../../../core/services/app_info_service.dart';
import '../../../../responsive.dart';
import '../../../app_configuration/domain/entities/app_version.dart';
import '../../../app_configuration/presentation/providers/app_configuration_providers.dart';
import '../../domain/entities/branch.dart';
import '../../domain/extensions/branch_extensions.dart';
import '../providers/branch_providers.dart';
import '../widgets/app_update_bottom_sheet.dart';
import '../widgets/branch_details_section.dart';
import '../widgets/branch_info_row.dart';
import '../widgets/branch_rings_list.dart';
import '../widgets/branch_status_badge.dart';

/// Full screen branch selection with gradient background.
///
/// Displays branches as horizontal scrollable rings with selected
/// branch details shown below.
class BranchSelectionScreen extends ConsumerStatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  ConsumerState<BranchSelectionScreen> createState() =>
      _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends ConsumerState<BranchSelectionScreen> {
  int _selectedIndex = 0;
  bool _hasShownAppUpdateSheet = false;

  @override
  Widget build(BuildContext context) {
    final appConfigAsync = ref.watch(appConfigurationProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final appInfoAsync = ref.watch(appInfoProvider);
    final userPositionAsync = ref.watch(userPositionForBranchProvider);
    final position = userPositionAsync.value;
    final userPosition = position != null
        ? (lat: position.latitude, lng: position.longitude)
        : null;

    // Wrap with GPS guard - ensures GPS is enabled before showing branch selection
    return LocationGpsGuardPerscreen(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.7, 1.0],
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.95),
                  AppColors.primary.withValues(alpha: 0.9),
                  AppColors.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated floating circle - top right
                _buildAnimatedCircle(
                  right: -50,
                  top: 80,
                  size: 180,
                  opacity: 0.06,
                  duration: 3,
                ),
                // Animated floating circle - bottom left
                _buildAnimatedCircle(
                  left: -40,
                  bottom: 150,
                  size: 140,
                  opacity: 0.04,
                  duration: 4,
                ),
                Center(
                  child: ConstrainedBox(
                    // Limit the Column to 600 width
                   constraints: const BoxConstraints(maxWidth: 700),
                    child: appConfigAsync.when(
                      data: (config) => appInfoAsync.when(
                        data: (appInfo) => branchesAsync.when(
                          data: (branches) {
                            _maybeShowAppUpdateSheet(
                              context: context,
                              backend: config.appVersion,
                              current: appInfo,
                            );
                    
                            if (branches.isEmpty) {
                              return EmptyState(
                                icon: Icons.store_outlined,
                                title: 'No Branches Available',
                                subtitle:
                                    'There are no branches available at the moment.',
                              );
                            }
                    
                            final selectedBranch = branches[_selectedIndex];
                            return _buildContent(
                              branches,
                              selectedBranch,
                              userPosition,
                              context
                            );
                          },
                          loading: () => const BranchSelectionSkeleton(),
                          error: (error, stackTrace) {
                            Logger().e(
                              'Branch selection: branches load failed',
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return const BranchSelectionSkeleton();
                          },
                        ),
                        loading: () => const BranchSelectionSkeleton(),
                        error: (error, stackTrace) {
                          Logger().e(
                            'Branch selection: app info failed',
                            error: error,
                            stackTrace: stackTrace,
                          );
                          return const BranchSelectionSkeleton();
                        },
                      ),
                      loading: () => const BranchSelectionSkeleton(),
                      error: (error, stackTrace) {
                        Logger().e(
                          'Branch selection: app config failed',
                          error: error,
                          stackTrace: stackTrace,
                        );
                        return const BranchSelectionSkeleton();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _maybeShowAppUpdateSheet({
    required BuildContext context,
    required AppVersion backend,
    required AppInfo current,
  }) {
    if (_hasShownAppUpdateSheet) return;

    final shouldShow =
        backend.version != current.version ||
        backend.buildNumber != current.buildNumber;
    if (!shouldShow) return;

    _hasShownAppUpdateSheet = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final isBlocking = backend.mustBeBlocking;

      await showModalBottomSheet<void>(
        context: context,
        isDismissible: !isBlocking,
        enableDrag: !isBlocking,
        isScrollControlled: true,
        barrierColor: isBlocking ? Colors.black54 : Colors.transparent,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          final height = MediaQuery.sizeOf(ctx).height;
          return SizedBox(
            height: isBlocking ? height : null,
            child: AppUpdateBottomSheet(
              backend: backend,
              current: current,
              isBlocking: isBlocking,
            ),
          );
        },
      );
    });
  }

  Widget _buildAnimatedCircle({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required double opacity,
    required int duration,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: opacity),
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                duration: Duration(seconds: duration),
                begin: const Offset(1, 1),
                end: const Offset(1.15, 1.15),
              )
              .then()
              .scale(
                duration: Duration(seconds: duration),
                begin: const Offset(1.15, 1.15),
                end: const Offset(1, 1),
              ),
    );
  }

  Widget _buildContent(
    List<Branch> branches,
    Branch selectedBranch,
    ({double lat, double lng})? userPosition,
    BuildContext context,
  ) { 
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 60),
      
          // Description text - centered
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
            child: Text(
              AppTexts.selectBranchDescription,
              style: AppTextStyles.h5.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      
           SizedBox(height: context.isTablet ? AppSizes.xxxl:  AppSizes.xl),
          BranchStatusBadge(isOpen: selectedBranch.isCurrentlyOpen),
          const SizedBox(height: AppSizes.lg),
      
          // Phone and Working Hours
          BranchInfoRow(
            phone: selectedBranch.contactPhone,
            openingHour: selectedBranch.openingHour,
            closingHour: selectedBranch.closingHour,
          ),
      
          const SizedBox(height: AppSizes.xxl),
      
          // Branch rings - horizontal scroll
          BranchRingsList(
            branches: branches,
            selectedIndex: _selectedIndex,
            userPosition: userPosition,
            onBranchSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
      
          const SizedBox(height: AppSizes.xxl),
      
          // Selected branch details - natural height
          BranchDetailsSection(
            branch: selectedBranch,
            userPosition: userPosition,
          ),
      
          SizedBox(height: context.isTablet ? AppSizes.xxxl:  AppSizes.xl),
      
          // Open button
          _buildOpenButton(selectedBranch, userPosition),
      
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  Widget _buildOpenButton(
    Branch branch,
    ({double lat, double lng})? userPosition,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: CustomButton(
        width: context.isTablet ? 400 : null,
        text: 'CONTINUE >>>',
        textColor: AppColors.white,
        onPressed: () {
          // First clear the branch id, distance, and working hours if they exist
          ref.read(currentBranchProvider.notifier).clear();
          ref.read(currentBranchDistanceProvider.notifier).clear();
          ref.read(currentBranchWorkingHoursProvider.notifier).clear();

          // Store the selected branch ID and check if successful
          final branchSuccess = ref
              .read(currentBranchProvider.notifier)
              .set(branch.id);
          if (!branchSuccess) return;

          // Store the selected branch opening and closing hours
          ref
              .read(currentBranchWorkingHoursProvider.notifier)
              .setFromBranch(branch.openingHour, branch.closingHour);

          if (userPosition != null) {
            final distanceKm = DistanceCalculator.distanceInKm(
              userPosition,
              branch.location,
            );
            ref.read(currentBranchDistanceProvider.notifier).set(distanceKm);
          }
          // IMPORTANT: Use `go()` (not `push()`) when entering the tab shell routes (Home/Cart/Order/Profile).
          // `push()` can create an inconsistent stack across nested navigators and later cause navigation/layout issues.
          context.go(RouteName.home);
          // If setting failed, the user stays on the branch selection screen
          // This is a safety measure - in practice, this should rarely fail
        },
      ),
    );
  }
}
