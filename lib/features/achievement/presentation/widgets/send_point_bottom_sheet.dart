import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../providers/achievement_providers.dart';

class SendPointBottomSheet extends ConsumerStatefulWidget {
  const SendPointBottomSheet({super.key});

  @override
  ConsumerState<SendPointBottomSheet> createState() =>
      _SendPointBottomSheetState();
}

class _SendPointBottomSheetState extends ConsumerState<SendPointBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pointController;
  late final TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pointController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _pointController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (_formKey.currentState?.validate() ?? false) {
      final point = int.tryParse(_pointController.text.trim());
      if (point == null || point <= 0) {
        final snackbar = ref.read(snackbarServiceProvider);
        snackbar.showError(
          const Failure.validation(message: 'Invalid point amount'),
        );
        return;
      }

      final phone = '251${_phoneController.text.trim()}';

      setState(() => _isLoading = true);

      try {
        await ref.read(sendPointProvider(point, phone).future);
        if (mounted) {
          context.pop();
          final snackbar = ref.read(snackbarServiceProvider);
          snackbar.showSuccess('Points sent successfully');
          // Invalidate providers to refresh data
          ref.invalidate(achievementPointProvider);
          ref.invalidate(achievementHistoryProvider);
        }
      } catch (e) {
        if (mounted) {
          final snackbar = ref.read(snackbarServiceProvider);
          snackbar.showError(
            e is Failure ? e : Failure.unexpected(message: e.toString()),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLg),
          topRight: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSizes.lg,
        right: AppSizes.lg,
        top: AppSizes.lg,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Text(
              'Send Points',
              style: AppTextStyles.h4.copyWith(color: AppColors.txtPrimary),
            ),
            const SizedBox(height: AppSizes.xl),
            // Point field
            Text(
              'Points',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.txtSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            InputTextfield(
              controller: _pointController,
              hintText: 'Enter amount',
              icon: Icons.account_balance_wallet_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Points is required';
                }
                final point = int.tryParse(value.trim());
                if (point == null || point <= 0) {
                  return 'Enter a valid point amount';
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppSizes.lg),
            // Phone field
            Text(
              'Phone Number',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.txtSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            InputTextfield(
              controller: _phoneController,
              hintText: 'Enter phone number',
              icon: Icons.phone,
              prefixText: '+251 ',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }
                final isValid = Validators.isValidEthiopianPhone(value.trim());
                return isValid ? null : 'Enter a valid phone number';
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            const SizedBox(height: AppSizes.xl),
            // Send button
            CustomButton(
              text: 'Send Points',
              onPressed: _isLoading ? null : _handleSend,
              isLoading: _isLoading,
              loadingText: 'Sending...',
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + AppSizes.lg,
            ),
          ],
        ),
      ),
    );
  }
}
