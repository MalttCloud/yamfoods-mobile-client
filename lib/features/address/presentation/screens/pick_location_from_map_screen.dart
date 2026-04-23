import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/permissions/location/location_permission_service.dart';
import '../widgets/location_map_picker.dart';

/// Full-screen map picker.
///
/// User taps on the map to select a location.
/// If no initial coordinates provided, fetches current GPS location.
class PickLocationFromMapScreen extends ConsumerStatefulWidget {
  /// If null, will fetch current GPS location
  final double? initialLat;
  final double? initialLng;

  const PickLocationFromMapScreen({
    super.key,
    this.initialLat,
    this.initialLng,
  });

  @override
  ConsumerState<PickLocationFromMapScreen> createState() =>
      _PickLocationFromMapScreenState();
}

class _PickLocationFromMapScreenState
    extends ConsumerState<PickLocationFromMapScreen> {
  double? _selectedLat;
  double? _selectedLng;
  bool _isLoadingInitial = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    // If coordinates provided, use them
    if (widget.initialLat != null && widget.initialLng != null) {
      setState(() {
        _selectedLat = widget.initialLat;
        _selectedLng = widget.initialLng;
        _isLoadingInitial = false;
      });
      return;
    }

    // Otherwise fetch current GPS location
    try {
      final position = await LocationPermissionService.requestCurrentLocation();
      setState(() {
        _selectedLat = position.latitude;
        _selectedLng = position.longitude;
        _isLoadingInitial = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingInitial = false;
        _errorMessage = 'Could not get your location. Please try again.';
      });
    }
  }

  void _onLocationSelected(double lat, double lng) {
    setState(() {
      _selectedLat = lat;
      _selectedLng = lng;
      _errorMessage = null;
    });
  }

  void _onPickPressed() {
    if (_selectedLat == null || _selectedLng == null) {
      setState(() {
        _errorMessage = 'Please select a location on the map';
      });
      return;
    }

    context.pop(<String, double>{'lat': _selectedLat!, 'lng': _selectedLng!});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Pick Location'),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: _isLoadingInitial
                  ? _buildLoadingState()
                  : _selectedLat != null && _selectedLng != null
                  ? LocationMapPicker(
                      initialLat: _selectedLat!,
                      initialLng: _selectedLng!,
                      onLocationSelected: _onLocationSelected,
                    )
                  : _buildErrorState(),
            ),
          ),
          // Bottom section with coordinates and button
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected location display
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Location',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.txtSecondary,
                            ),
                          ),
                          if (_selectedLat != null && _selectedLng != null)
                            Text(
                              'Lat: ${_selectedLat!.toStringAsFixed(6)}, Lng: ${_selectedLng!.toStringAsFixed(6)}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.txtPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            Text(
                              'Tap on map to select',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.txtSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                // Pick button
                CustomButton(
                  text: 'Pick this location',
                  onPressed: _onPickPressed,
                  isLoading: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Getting your location...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.txtSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 48,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'Could not get location',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.txtPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isLoadingInitial = true;
                  _errorMessage = null;
                });
                _initializeLocation();
              },
              icon: Icon(Icons.refresh_rounded, color: AppColors.primary),
              label: Text(
                'Try Again',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
