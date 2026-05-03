import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/custom_textfield.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/services/snackbar_service.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/request_otp_event.dart';
import '../providers/events/validate_otp_event.dart';

class ValidateOtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool isDeleteAccountFlow;

  const ValidateOtpScreen({
    super.key,
    required this.phoneNumber,
    this.isDeleteAccountFlow = false,
  });

  @override
  ConsumerState<ValidateOtpScreen> createState() => _ValidateOtpScreenState();
}

class _ValidateOtpScreenState extends ConsumerState<ValidateOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();



  void _validateOTP() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _otpController.text.trim();
      ref
          .read(authProvider.notifier)
          .validateOtp(otp: otp, phone: widget.phoneNumber);
    }
  }

  void _resendOTP() {
    ref
        .read(authProvider.notifier)
        .requestResetPasswordOtp(phone: widget.phoneNumber);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ValidateOtpEvent?>(validateOtpEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is ValidateOtpSuccess) {
        snackbar.showSuccess('OTP validated successfully!');
        if (widget.isDeleteAccountFlow) {
          context.pop(true);
        } else {
          context.push(RouteName.resetPassword, extra: widget.phoneNumber);
        }
      } else if (next is ValidateOtpFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(validateOtpEventsProvider.notifier).clear();
    });

    ref.listen<RequestOtpEvent?>(requestOtpEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is RequestOtpSuccess) {
        snackbar.showSuccess('Otp sent to your phone, check your sms app!');
      } else if (next is RequestOtpFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(requestOtpEventsProvider.notifier).clear();
    });

    final isLoading = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSizes.authScreensMaxWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      AppTexts.validateOTP,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppTexts.validateOTPDesc,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSizes.lg),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(AppSizes.radius),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: AppSizes.iconSize,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Text(
                            widget.phoneNumber,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.txtSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: AppTexts.enterOTP,
                      controller: _otpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppTexts.enterValidOTP;
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                      prefixIcon: Icons.security,
                      inputType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: AppTexts.validateOTP,
                      onPressed: _validateOTP,
                      isLoading: isLoading,
                      loadingText: 'Validating OTP...',
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: _resendOTP,
                      child: Text(
                        AppTexts.resendOTP,
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
}
