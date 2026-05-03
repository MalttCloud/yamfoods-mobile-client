import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/custom_textfield.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../../data/services/google_sign_in_service.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/register_event.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref
          .read(authProvider.notifier)
          .register(name: name, email: email, password: password);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterUiEvent?>(registerUiEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is RegisterSuccess) {
        snackbar.showSuccess('You are registered successfully!');
        if (next.user.phone == null) {
          context.push(RouteName.savePhone, extra: next.user.id);
        }
        //These below are checked because user will try toregister with existing email through google sign in
        //since we allow that existing user can register through google if provider is google
        else if (next.user.phone != null && next.user.phoneVerified == true) {
          context.go(RouteName.branches);
        } else if (next.user.phone != null &&
            next.user.phoneVerified == false) {
          context.push(RouteName.verifyPhone, extra: next.user);
        }
      } else if (next is RegisterFailure) {
        snackbar.showError(next.failure);
      }

      ref.read(registerUiEventsProvider.notifier).clear();
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
                    AppTexts.registerAccount,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppTexts.createAccount,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    labelText: AppTexts.enterName,
                    controller: _nameController,
                    validator: Validators.validateName,
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    labelText: AppTexts.enterEmail,
                    controller: _emailController,
                    validator: (value) {
                      final isValid = Validators.isValidEmail(value ?? '');
                      return isValid ? null : AppTexts.enterValidEmail;
                    },
                    prefixIcon: Icons.email,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    labelText: AppTexts.enterPassword,
                    controller: _passwordController,
                    validator: (value) {
                      final isValid = Validators.isValidPassword(value ?? '');
                      return isValid ? null : AppTexts.enterValidPassword;
                    },
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    labelText: AppTexts.confirmPassword,
                    controller: _confirmPasswordController,
                    validator: (val) => Validators.confirmPassword(
                      val,
                      _passwordController.text,
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
                  const SizedBox(height: 20),
                  CustomButton(
                    text: AppTexts.register,
                    onPressed: _submit,
                    isLoading: isLoading,
                    loadingText: 'Registering...',
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppTexts.or,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(thickness: 1, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: 'Register with Google',
                    onPressed: isLoading
                        ? null
                        : () async {
                            String? idToken;
                            try {
                              // Get Firebase ID token from Google Sign-In
                              // Only catch errors from token retrieval
                              idToken = await GoogleSignInService.signIn();
                            } catch (e) {
                              // Handle Google Sign-In token retrieval errors
                              final snackbar = ref.read(
                                snackbarServiceProvider,
                              );
                              snackbar.showError(
                                Failure.unexpected(
                                  message:
                                      'Something went wrong when signing in with Google. Please contact support!',
                                ),
                              );
                              return; // Exit early if token retrieval fails
                            }

                            // If idToken is null, user cancelled - do nothing
                            if (idToken == null) return;

                            // Authenticate with backend
                            // Backend errors are handled by the auth event system
                            ref
                                .read(authProvider.notifier)
                                .googleSignIn(
                                  idToken: idToken,
                                  isRegistering: true,
                                );
                          },
                    isLoading: isLoading,
                    isSocial: true,
                    color: AppColors.btnSecondary,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: AppTexts.agree),
                          TextSpan(
                            text: AppTexts.termOfUse,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(RouteName.termsAndConditions);
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: AppTexts.privacyPolicy,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(RouteName.privacyPolicy);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: AppTexts.alreadyHaveAccount,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(fontSize: 14),
                        children: [
                          TextSpan(
                            text: AppTexts.login,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go(RouteName.login);
                              },
                          ),
                        ],
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
