import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../shared/models/validate_otp_arg.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../providers/info_providers.dart';
import '../widgets/delete_account_success_dialog.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  static const int _phoneMax = 15;
  static const int _titleMax = 100;
  static const int _reasonMax = 200;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _titleController = TextEditingController(text: 'Delete my account');
  final _reasonController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const DeleteAccountSuccessDialog(),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _titleController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isSubmitting = true);
    final snackbar = ref.read(snackbarServiceProvider);

    try {
      final params = (
        phone: Validators.formatEthiopianPhone(_phoneController.text),
        title: _titleController.text.trim(),
        reason: _reasonController.text.trim(),
      );

      await deleteMyAccountMutation(ref, params);
      if (!mounted) return;

      setState(() => _isSubmitting = false);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;

      final otpValidated = await context.push<bool>(
        RouteName.validateOtp,
        extra: ValidateOtpArg(
          phoneNumber: params.phone,
          isDeleteAccountFlow: true,
        ),
      );
      if (!mounted) return;

      if (otpValidated == true) {
        await _showSuccessDialog();
      }
      if (!mounted) return;
      context.pop();
    } catch (e) {
      snackbar.showError(
        e is Failure ? e : Failure.unexpected(message: e.toString()),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Delete Account'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Center(
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
                    Text(
                      'We are sorry to see you go',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please confirm your phone number and share a reason for deleting your account.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Phone Number'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _phoneController,
                      hintText: '0912345678',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      maxLength: _phoneMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_phoneMax),
                      ],
                      validator: (value) {
                        final isValid = Validators.isValidEthiopianPhone(
                          value ?? '',
                        );
                        return isValid
                            ? null
                            : 'Please enter a valid phone number';
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Title'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _titleController,
                      hintText: 'Delete my account',
                      icon: Icons.title_rounded,
                      maxLength: _titleMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_titleMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Please enter a title';
                        if (v.length > _titleMax) {
                          return 'Title must be $_titleMax characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Reason'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _reasonController,
                      hintText: 'I no longer use this account',
                      icon: Icons.message_outlined,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      maxLength: _reasonMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_reasonMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Please enter a reason';
                        if (v.length > _reasonMax) {
                          return 'Reason must be $_reasonMax characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                    CustomButton(
                      text: 'Submit',
                      onPressed: _isSubmitting ? null : _submit,
                      isLoading: _isSubmitting,
                      loadingText: 'Submitting...',
                    ),
                    
                  ],
                ),
              ),
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
}
