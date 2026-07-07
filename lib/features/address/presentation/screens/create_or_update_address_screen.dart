import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/address_request_data.dart';
import '../../domain/entities/delivery_address_payload.dart';
import '../../../auth/presentation/providers/auth_user_state.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/address_events.dart';
import '../providers/address_loading_providers.dart';
import '../providers/address_notifier.dart';
import '../providers/location_selection_provider.dart';

class CreateOrUpdateAddressScreen extends ConsumerStatefulWidget {
  final Address? address;
  final DeliveryAddressPayload? initialLocation;

  const CreateOrUpdateAddressScreen({
    super.key,
    this.address,
    this.initialLocation,
  });

  @override
  ConsumerState<CreateOrUpdateAddressScreen> createState() =>
      _CreateOrUpdateAddressScreenState();
}

enum AddressLabel { home, work, other }

class _CreateOrUpdateAddressScreenState
    extends ConsumerState<CreateOrUpdateAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _receiverNameController;
  late final TextEditingController _receiverPhoneController;
  late final TextEditingController _labelOtherController;
  AddressLabel? _selectedLabel;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
      text: widget.address?.address ?? '',
    );
    final isUpdate = widget.address != null;
    _receiverNameController = TextEditingController(
      text: widget.address?.receiverName ?? '',
    );
    _receiverPhoneController = TextEditingController(
      text: widget.address?.receiverPhone ?? '',
    );
    _labelOtherController = TextEditingController();
    final existingLabel = widget.address?.label;
    if (existingLabel != null && existingLabel.isNotEmpty) {
      switch (existingLabel.toLowerCase()) {
        case 'home':
          _selectedLabel = AddressLabel.home;
          break;
        case 'work':
          _selectedLabel = AddressLabel.work;
          break;
        default:
          _selectedLabel = AddressLabel.other;
          _labelOtherController.text = existingLabel;
      }
    } else {
      // Default label is Home (create or no label on address)
      _selectedLabel = AddressLabel.home;
    }

    // Initialize location and autofill from user when creating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        final lat = double.tryParse(widget.address!.lat);
        final lng = double.tryParse(widget.address!.lng);

        if (widget.initialLocation != null) {
          ref
              .read(locationSelectionProvider.notifier)
              .initializeWithExistingAddress(
                widget.initialLocation!.lat,
                widget.initialLocation!.lng,
              );
          final placeName = widget.initialLocation!.placeName;
          if (placeName != null && placeName.isNotEmpty) {
            _addressController.text = placeName;
          }
        } else if (lat != null && lng != null) {
          ref
              .read(locationSelectionProvider.notifier)
              .initializeWithExistingAddress(lat, lng);
        }
      } else if (widget.initialLocation != null) {
        final location = widget.initialLocation!;
        ref
            .read(locationSelectionProvider.notifier)
            .initializeWithExistingAddress(location.lat, location.lng);
        if (location.placeName != null && location.placeName!.isNotEmpty) {
          _addressController.text = location.placeName!;
        }
        final user = ref.read(currentUserProvider);
        if (user != null && mounted) {
          _receiverNameController.text = user.name;
          _receiverPhoneController.text = user.phone ?? '';
        }
        if (mounted) setState(() {});
      } else {
        // Create mode: autofill receiver name and phone from current user
        final user = ref.read(currentUserProvider);
        if (user != null && mounted) {
          _receiverNameController.text = user.name;
          _receiverPhoneController.text = user.phone ?? '';
          setState(() {});
        }
        // Provider already fetches current location on build()
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _labelOtherController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final locationState = ref.read(locationSelectionProvider);
      final snackbar = ref.read(snackbarServiceProvider);

      // Check if coordinates are available
      if (locationState.selectedLat == null ||
          locationState.selectedLng == null) {
        snackbar.showError(
          const Failure.validation(
            message: 'Please select a location before submitting.',
          ),
        );
        return;
      }

      // Validate coordinate ranges
      final coordValidation = Validators.validateCoordinates(
        locationState.selectedLat!,
        locationState.selectedLng!,
      );
      if (coordValidation != null) {
        snackbar.showError(coordValidation);
        return;
      }

      String? labelValue;
      if (_selectedLabel != null) {
        switch (_selectedLabel!) {
          case AddressLabel.home:
            labelValue = 'Home';
            break;
          case AddressLabel.work:
            labelValue = 'Work';
            break;
          case AddressLabel.other:
            final other = _labelOtherController.text.trim();
            labelValue = other.isEmpty ? null : other;
            break;
        }
      }
      final data = AddressRequestData(
        address: _addressController.text.trim(),
        receiverName: _receiverNameController.text.trim().isEmpty
            ? null
            : _receiverNameController.text.trim(),
        receiverPhone: _receiverPhoneController.text.trim().isEmpty
            ? null
            : _receiverPhoneController.text.trim(),
        label: labelValue,
        lat: locationState.selectedLat!,
        lng: locationState.selectedLng!,
      );

      if (widget.address == null) {
        // Create new address
        await ref.read(addressProvider.notifier).create(data);
      } else {
        // Update existing address
        await ref
            .read(addressProvider.notifier)
            .updateAddress(id: widget.address!.id, data: data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for address events
    ref.listen<AddressUiEvent?>(addressUiEventsProvider, (prev, next) {
      if (next == null) return;
      if (next is AddressCreated || next is AddressUpdated) {
        context.pop();
      }
      ref.read(addressUiEventsProvider.notifier).clear();
    });

    // Watch location and reverse-geocode: auto-fill address from coordinates
    final locationState = ref.watch(locationSelectionProvider);
    final lat = locationState.selectedLat;
    final lng = locationState.selectedLng;
    final hasPrefilledPlaceName = widget.initialLocation?.placeName != null &&
        widget.initialLocation!.placeName!.isNotEmpty;
    final reverseGeocodeAsync = (lat != null && lng != null && !hasPrefilledPlaceName)
        ? ref.watch(reverseGeocodeProvider(lat, lng))
        : null;

    if (lat != null && lng != null && !hasPrefilledPlaceName) {
      ref.listen(reverseGeocodeProvider(lat, lng), (prev, next) {
        next.whenOrNull(
          data: (address) {
            if (mounted && address.isNotEmpty) {
              _addressController.text = address;
            }
          },
          error: (_, __) {
            if (mounted) {
              ref
                  .read(snackbarServiceProvider)
                  .showError(
                    const Failure.mapError(
                      'Could not get address for this location.',
                    ),
                  );
            }
          },
        );
      });
    }

    final isFetchingAddress = reverseGeocodeAsync?.isLoading ?? false;
    final isCreating = widget.address == null;
    final isLoading = isCreating
        ? ref.watch(addressCreateLoadingProvider)
        : ref
              .watch(addressUpdateLoadingProvider)
              .contains(widget.address?.id ?? 0);

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: isCreating ? 'Add Address' : 'Update Address',
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(AppSizes.lg),
          child:
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
                  child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildLabel('Address *'),
                                  if (isFetchingAddress) ...[
                                    const SizedBox(width: AppSizes.sm),
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSizes.xs),
                                    Text(
                                      'Fetching address...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.txtSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: AppSizes.sm),
                              InputTextfield(
                                controller: _addressController,
                                hintText: 'Delivery address',
                                icon: Icons.location_on_rounded,
                                validator: Validators.validateAddress,
                                keyboardType: TextInputType.multiline,
                                maxLength: 100,
                                maxLines: 3,
                                readOnly: true,
                              ),
                              const SizedBox(height: AppSizes.lg),
                        
                              // Receiver Name (Optional)
                              _buildLabel('Receiver Name'),
                              const SizedBox(height: AppSizes.sm),
                              InputTextfield(
                                controller: _receiverNameController,
                                hintText: 'Enter receiver name',
                                icon: Icons.person_rounded,
                                validator: Validators.validateReceiverName,
                                keyboardType: TextInputType.name,
                                maxLength: 30,
                              ),
                              const SizedBox(height: AppSizes.lg),
                        
                              // Receiver Phone (Optional)
                              _buildLabel('Receiver Phone'),
                              const SizedBox(height: AppSizes.sm),
                              InputTextfield(
                                controller: _receiverPhoneController,
                                hintText: 'Enter receiver phone',
                                icon: Icons.phone_rounded,
                                validator: Validators.validateReceiverPhone,
                                keyboardType: TextInputType.phone,
                                maxLength: 20,
                              ),
                              const SizedBox(height: AppSizes.lg),
                        
                              // Label: Home, Work, Other (Optional)
                              _buildLabel('Label'),
                              const SizedBox(height: AppSizes.sm),
                              Row(
                                children: [
                                  _buildLabelChip(
                                    AddressLabel.home,
                                    'Home',
                                    Icons.home_rounded,
                                  ),
                                  SizedBox(width: AppSizes.sm),
                                  _buildLabelChip(
                                    AddressLabel.work,
                                    'Work',
                                    Icons.work_rounded,
                                  ),
                                  SizedBox(width: AppSizes.sm),
                                  _buildLabelChip(
                                    AddressLabel.other,
                                    'Other',
                                    Icons.label_rounded,
                                  ),
                                ],
                              ),
                              if (_selectedLabel == AddressLabel.other) ...[
                                const SizedBox(height: AppSizes.sm),
                                InputTextfield(
                                  controller: _labelOtherController,
                                  hintText: 'Enter label (e.g. Gym, Parents)',
                                  icon: Icons.edit_rounded,
                                  keyboardType: TextInputType.text,
                                  maxLength: 50,
                                ),
                              ],
                              const SizedBox(height: AppSizes.xl),
                        
                              // Submit Button
                              CustomButton(
                                text: isCreating ? 'Add Address' : 'Update Address',
                                onPressed: _handleSubmit,
                                isLoading: isLoading,
                                loadingText: isCreating
                                    ? 'Adding address...'
                                    : 'Updating address...',
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.txtSecondary.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildLabelChip(AddressLabel value, String label, IconData icon) {
    final isSelected = _selectedLabel == value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(
          () => _selectedLabel = _selectedLabel == value ? null : value,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.12)
                : AppColors.background.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primary : AppColors.txtSecondary,
              ),
              SizedBox(width: AppSizes.xs),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.txtSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
