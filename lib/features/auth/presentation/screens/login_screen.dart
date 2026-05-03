import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/custom_textfield.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/routes/target_screen_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_texts.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/permissions/notification/notification_fcm_service.dart';
import '../../../notification/presentation/providers/notification_providers.dart';
import '../../data/services/google_sign_in_service.dart';
import '../providers/auth_notifier.dart';
import '../providers/events/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = Validators.formatEthiopianPhone(_phoneController.text);
      final password = _passwordController.text.trim();
      ref.read(authProvider.notifier).login(phone: phone, password: password);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _resendOTP(String phone) {
    ref.read(authProvider.notifier).requestResetPasswordOtp(phone: phone);
  }

  /// Saves FCM token to backend and subscribes to notification topics.
  ///
  /// This is called after successful login. Errors are silently handled
  /// to avoid disrupting the login flow.
  Future<void> _saveFcmTokenAndSubscribe(WidgetRef ref) async {
    try {
      final fcmService = NotificationFcmService.instance;
      final token = await fcmService.getToken();

      if (token == null) {
        debugPrint('FCM token not available');
        return;
      }

      final deviceType = NotificationFcmService.getDeviceType();

      // Save token to backend
      await ref.read(
        saveOrUpdateFcmTokenProvider((
          token: token,
          deviceType: deviceType,
        )).future,
      );

      // Subscribe to topics after successful save
      await fcmService.subscribeToUserTopics();

      debugPrint('FCM token saved and topics subscribed successfully');
    } catch (e) {
      // Silently handle errors - don't disrupt login flow
      debugPrint('Error saving FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthEvent?>(authEventsProvider, (previous, next) {
      if (next == null) return;

      final snackbar = ref.read(snackbarServiceProvider);

      if (next is Authenticated) {
        // Check if phone needs verification
        if (next.user.phoneVerified == false && next.user.phone != null) {
          _resendOTP(next.user.phone!);
          context.push(RouteName.verifyPhone, extra: next.user);
          ref.read(authEventsProvider.notifier).clear();
          return;
        }
        if (next.user.phone == null) {
          context.push(RouteName.savePhone, extra: next.user.id);
          ref.read(authEventsProvider.notifier).clear();
          return;
        } 

        // User is fully authenticated
        // Defer navigation and provider modification to after current frame
        // This prevents "modify provider during build" errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          // Save FCM token and subscribe to topics (non-blocking)
          _saveFcmTokenAndSubscribe(ref);

          // Check if there's a target screen to navigate to
          final targetScreen = ref.read(targetScreenProvider);
          if (targetScreen != null) {
            // Navigate to the target screen user wanted to access
            context.go(targetScreen);
            // Clear target screen after navigation
            ref.read(targetScreenProvider.notifier).clear();
          } else {
            // No target screen - navigate to home
            context.go(RouteName.branches);
          }

          // Show success snackbar AFTER navigation completes
          // This prevents Navigator state conflicts
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              snackbar.showSuccess('Login successful!');
            }
          });
        });
      } else if (next is AuthenticationFailure) {
        final failure = next.failure;

        // Check if it's phone not verified (status code 403)
        if (failure is AuthFailure && failure.statusCode == 403) {
          if (mounted) {
            final phone = Validators.formatEthiopianPhone(
              _phoneController.text,
            );
            // Navigate to Verify Phone screen
            context.push(RouteName.verifyPhone, extra: phone);
            ref.read(authEventsProvider.notifier).clear();
            return;
          }
        }

        // Show error for other authentication failures
        snackbar.showError(failure);
      }

      ref.read(authEventsProvider.notifier).clear();
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
                    Text(
                      AppTexts.loginAccount,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppTexts.welcomeBack,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      // Visual prefix
                      prefixText: '+251 ',
                      inputType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
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
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push(RouteName.forgotPassword);
                        },
                        child: Text(
                          AppTexts.forgotPassword,
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomButton(
                      text: AppTexts.login,
                      onPressed: _submit,
                      isLoading: isLoading,
                      loadingText: 'Logging in...',
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
                    const SizedBox(height: 20),
                    CustomButton(
                      text: AppTexts.loginWithGoogle,
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
                                  .googleSignIn(idToken: idToken);
                            },
                      isLoading: isLoading,
                      isSocial: true,
                      color: AppColors.btnSecondary,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: AppTexts.dontHaveAccount,
                          style: TextStyle(color: AppColors.txtSecondary),
                          children: [
                            TextSpan(
                              text: AppTexts.signup,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push(RouteName.register);
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
