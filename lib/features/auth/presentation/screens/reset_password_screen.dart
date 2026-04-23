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
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/reset_password_event.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      final newPassword = _newPasswordController.text.trim();
      ref
          .read(authProvider.notifier)
          .resetPassword(phone: widget.phoneNumber, newPassword: newPassword);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ResetPasswordEvent?>(resetPasswordEventsProvider, (
      previous,
      next,
    ) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is ResetPasswordSuccess) {
        snackbar.showSuccess('Your password is changed successfully!');
        context.pushReplacement(RouteName.login);
      } else if (next is ResetPasswordFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(resetPasswordEventsProvider.notifier).clear();
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
                    AppTexts.resetPassword,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTexts.resetPasswordDesc,
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
                    labelText: AppTexts.enterNewPassword,
                    controller: _newPasswordController,
                    validator: (value) {
                      final isValid = Validators.isValidPassword(value ?? '');
                      return isValid ? null : AppTexts.enterValidPassword;
                    },
                    obscureText: _obscureNewPassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    labelText: AppTexts.enterConfirmPassword,
                    controller: _confirmPasswordController,
                    validator: (val) => Validators.confirmPassword(
                      val,
                      _newPasswordController.text,
                    ),
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: AppTexts.resetPassword,
                    onPressed: _resetPassword,
                    isLoading: isLoading,
                    loadingText: 'Resetting password...',
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
