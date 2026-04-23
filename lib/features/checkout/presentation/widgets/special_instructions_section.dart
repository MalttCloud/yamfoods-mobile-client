import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../providers/checkout_notifier.dart';

class SpecialInstructionsSection extends ConsumerStatefulWidget {
  final int branchId;
  const SpecialInstructionsSection({super.key, required this.branchId});

  @override
  ConsumerState<SpecialInstructionsSection> createState() =>
      _SpecialInstructionsSectionState();
}

class _SpecialInstructionsSectionState
    extends ConsumerState<SpecialInstructionsSection> {
  final TextEditingController _noteController = TextEditingController();
  bool _isInitialized = false;
  bool _isUpdatingFromState = false;

  @override
  void initState() {
    super.initState();
    // Listen to text changes and update checkout state
    _noteController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_isUpdatingFromState) return;

    final newNote = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    ref.read(checkoutProvider(widget.branchId).notifier).setNote(newNote);
  }

  @override
  void dispose() {
    _noteController.removeListener(_onTextChanged);
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider(widget.branchId));

    // Initialize controller with existing note (only once)
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (checkoutState.note != null && _noteController.text.isEmpty) {
          _isUpdatingFromState = true;
          _noteController.text = checkoutState.note!;
          _isUpdatingFromState = false;
        }
        _isInitialized = true;
      });
    }

    // Sync controller with state if state changed externally
    if (_isInitialized && checkoutState.note != _noteController.text.trim()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (checkoutState.note != _noteController.text.trim()) {
          _isUpdatingFromState = true;
          _noteController.text = checkoutState.note ?? '';
          _isUpdatingFromState = false;
        }
      });
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.note_outlined, size: 20, color: AppColors.txtPrimary),
              SizedBox(width: AppSizes.xs),
              Text(
                'Special Instructions',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.txtPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          // Text field
          InputTextfield(
            controller: _noteController,
            hintText: 'Add any special instructions (optional)',
            icon: Icons.edit_note_outlined,
            maxLines: 3,
            maxLength: 100,
          ),
        ],
      ),
    );
  }
}
