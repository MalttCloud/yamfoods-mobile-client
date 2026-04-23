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
import '../../domain/entities/user.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/request_otp_event.dart';
import '../providers/events/verify_phone_event.dart';

class VerifyPhoneScreen extends ConsumerStatefulWidget {
  final User? user;
  final String? phone;

  const VerifyPhoneScreen({super.key, this.user, this.phone});

  @override
  ConsumerState<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends ConsumerState<VerifyPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String phone = '';

  String getPhone() {
    if (widget.user == null && widget.phone != null) {
      phone = widget.phone!;
    } else {
      phone = widget.user!.phone!;
    }
    return phone;
  }

  void _verifyPhone() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _otpController.text.trim();
      ref
          .read(authProvider.notifier)
          .verifyPhone(
            otp: otp,
            phone: getPhone(),
          ); //we are very sure phone is never null
    }
  }

  void _resendOTP() {
    ref.read(authProvider.notifier).requestResetPasswordOtp(phone: getPhone());
  }

  void _editPhone() {
    context.pushReplacement(RouteName.savePhone, extra: widget.user!.id);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<VerifyPhoneEvent?>(verifyPhoneEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is VerifyPhoneSuccess) {
        snackbar.showSuccess('Phone verified successfully');
        context.go(RouteName.branches);
      } else if (next is VerifyPhoneFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(verifyPhoneEventsProvider.notifier).clear();
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
                    AppTexts.verifyPhone,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTexts.verifyPhoneDesc,
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
                          getPhone(),
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
                    text: AppTexts.verifyPhone,
                    onPressed: _verifyPhone,
                    isLoading: isLoading,
                    loadingText: 'Verifying...',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                      if (widget.user != null)
                        TextButton(
                          onPressed: _editPhone,
                          child: Text(
                            AppTexts.editPhone,
                            style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
