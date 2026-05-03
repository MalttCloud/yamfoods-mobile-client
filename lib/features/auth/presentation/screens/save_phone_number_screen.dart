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
import '../providers/events/save_phone_event.dart';

class SavePhoneNumberScreen extends ConsumerStatefulWidget {
  final int userId;
  const SavePhoneNumberScreen({super.key, required this.userId});

  @override
  ConsumerState<SavePhoneNumberScreen> createState() =>
      _SavePhoneNumberScreenState();
}

class _SavePhoneNumberScreenState extends ConsumerState<SavePhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = Validators.formatEthiopianPhone(_phoneController.text);
      ref
          .read(authProvider.notifier)
          .savePhoneNumber(userId: widget.userId, phone: phone);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SavePhoneEvent?>(savePhoneEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is SavePhoneSuccess) {
        snackbar.showSuccess('Phone number saved successfully!');
        context.push(RouteName.verifyPhone, extra: next.user);
      } else if (next is SavePhoneFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(savePhoneEventsProvider.notifier).clear();
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
                      AppTexts.savePhoneNumber,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppTexts.savePhoneDesc,
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
                      text: AppTexts.savePhone,
                      onPressed: _submit,
                      isLoading: isLoading,
                      loadingText: 'Saving phone number...',
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
