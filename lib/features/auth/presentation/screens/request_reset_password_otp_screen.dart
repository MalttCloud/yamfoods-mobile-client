import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/custom_textfield.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/request_otp_event.dart';

class RequestResetPasswordOtpScreen extends ConsumerStatefulWidget {
  const RequestResetPasswordOtpScreen({super.key});

  @override
  ConsumerState<RequestResetPasswordOtpScreen> createState() =>
      _RequestResetPasswordOtpScreenState();
}

class _RequestResetPasswordOtpScreenState
    extends ConsumerState<RequestResetPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _sendOTP() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = Validators.formatEthiopianPhone(_phoneController.text);
      ref.read(authProvider.notifier).requestResetPasswordOtp(phone: phone);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RequestOtpEvent?>(requestOtpEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is RequestOtpSuccess) {
        snackbar.showSuccess('Otp sent to your phone, check your sms app!');
        final phone = Validators.formatEthiopianPhone(_phoneController.text);
        context.push(RouteName.validateOtp, extra: phone);
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
                    AppTexts.requestResetOTP,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTexts.requestResetDesc,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    labelText: AppTexts.enterPhone,
                    controller: _phoneController,
                    validator: (value) {
                      final isValid = Validators.isValidEthiopianPhone(
                        value ?? '',
                      );
                      return isValid ? null : AppTexts.enterValidPhone;
                    },
                    prefixIcon: Icons.phone,
                    prefixText: '+251 ',
                    inputType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: AppTexts.sendOTP,
                    onPressed: _sendOTP,
                    isLoading: isLoading,
                    loadingText: 'Sending OTP...',
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
