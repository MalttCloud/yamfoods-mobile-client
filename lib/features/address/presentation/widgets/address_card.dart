import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/confirmation_dialog.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../domain/entities/address.dart';
import '../providers/address_loading_providers.dart';
import '../providers/address_notifier.dart';

/// Clean address card — simple, modern, no clutter.
class AddressCard extends ConsumerWidget {
  final Address address;

  const AddressCard({super.key, required this.address});

  static const double _labelBgOpacity = 0.12;

  /// Same hue for leading bar and label; Home / Work / anything else use different colors.
  Color _colorForLabel(String? label) {
    if (label == null || label.trim().isEmpty) return AppColors.primary;
    final normalized = label.trim().toLowerCase();
    switch (normalized) {
      case 'home':
        return AppColors.primary;
      case 'work':
        return AppColors.info;
      default:
        return AppColors.primaryLight; // any other label (not home/work)
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleting = ref
        .watch(addressDeleteLoadingProvider)
        .contains(address.id);
    final isUpdating = ref
        .watch(addressUpdateLoadingProvider)
        .contains(address.id);
    final accentColor = _colorForLabel(address.label);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.md),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Leading bar — same color as label (Home / Work / Other)
              Container(
                width: 3,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(AppSizes.radius),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.lg,
                    vertical: AppSizes.md,
                  ),
                  child: _buildAddressContent(
                    context,
                    ref,
                    isDeleting,
                    isUpdating,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressContent(
    BuildContext context,
    WidgetRef ref,
    bool isDeleting,
    bool isUpdating,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label and action icons on same row so address fields stretch full width
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_hasLabel)
              () {
                final color = _colorForLabel(address.label);
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: _labelBgOpacity),
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    address.label!,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }(),
            const Spacer(),
            _buildActionIcons(context, ref, isDeleting, isUpdating),
          ],
        ),
        SizedBox(height: AppSizes.xs),
        _buildInfoRow(
          icon: Icons.location_on_outlined,
          text: address.address,
          isPrimary: true,
        ),
        if (_hasReceiverName) ...[
          SizedBox(height: AppSizes.xs),
          _buildInfoRow(
            icon: Icons.person_outline_rounded,
            text: 'Name: ${address.receiverName!}',
          ),
        ],
        if (_hasReceiverPhone) ...[
          SizedBox(height: AppSizes.xs),
          _buildInfoRow(
            icon: Icons.phone_outlined,
            text: 'Phone: ${address.receiverPhone!}',
            isSecondary: true,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    bool isPrimary = false,
    bool isSecondary = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isPrimary
              ? AppColors.primary
              : (isSecondary
                  ? AppColors.txtSecondary
                  : AppColors.primary.withValues(alpha: 0.8)),
        ),
        SizedBox(width: AppSizes.sm),
        Expanded(
          child: Text(
            text,
            style: isPrimary
                ? AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.txtPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  )
                : AppTextStyles.bodyMedium.copyWith(
                    color: isSecondary
                        ? AppColors.txtSecondary
                        : AppColors.txtPrimary,
                    height: 1.4,
                    fontWeight: isSecondary ? FontWeight.w400 : FontWeight.w500,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcons(
    BuildContext context,
    WidgetRef ref,
    bool isDeleting,
    bool isUpdating,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionIcon(
          icon: Icons.edit_outlined,
          onTap: isUpdating ? null : () => _handleEdit(context, ref),
          color: AppColors.primary,
          isLoading: isUpdating,
        ),
        SizedBox(width: AppSizes.xs),
        _buildActionIcon(
          icon: Icons.delete_outlined,
          onTap: isDeleting ? null : () => _handleDelete(context, ref),
          color: AppColors.error,
          isLoading: isDeleting,
        ),
      ],
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required VoidCallback? onTap,
    required Color color,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onTap,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              )
            : Icon(icon, color: color, size: 20),
        style: IconButton.styleFrom(
          foregroundColor: color,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, WidgetRef ref) {
    context.push(RouteName.deliveryAddress, extra: address);
  }

  void _handleDelete(BuildContext context, WidgetRef ref) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Address?',
      message:
          'Are you sure you want to delete this address? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmButtonColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(addressProvider.notifier).delete(id: address.id);
      }
    });
  }

  bool get _hasLabel =>
      address.label != null && address.label!.trim().isNotEmpty;
  bool get _hasReceiverName =>
      address.receiverName != null && address.receiverName!.trim().isNotEmpty;
  bool get _hasReceiverPhone =>
      address.receiverPhone != null && address.receiverPhone!.trim().isNotEmpty;
}
