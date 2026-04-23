import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/enums/feedback_type.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../providers/info_providers.dart';
import '../widgets/feedback_success_dialog.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  static const int _titleMax = 100;
  static const int _messageMax = 500;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  FeedbackType _type = FeedbackType.suggestion;
  bool _isSubmitting = false;

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const FeedbackSuccessDialog(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
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
        type: _type,
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
      );

      await ref.read(submitFeedbackProvider(params).future);
      if (!mounted) return;

      // Stop loading BEFORE showing the success dialog so the button
      // isn't still in "Submitting..." state behind the dialog.
      setState(() => _isSubmitting = false);
      await WidgetsBinding.instance.endOfFrame;

      await _showSuccessDialog();
      if (!mounted) return;
      context.pop(); // pop ONLY on success
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
      appBar: const CustomAppBar(title: 'Send Feedback'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
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
                  'Help us improve',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please share your feedback. We read every message.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txtSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),

                _buildLabel('Type'),
                const SizedBox(height: AppSizes.sm),
                DropdownButtonFormField<FeedbackType>(
                  initialValue: _type,
                  items: FeedbackType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: t.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(t.label),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: _isSubmitting ? null : (v) => setState(() => _type = v!),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radius),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md + 4,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.lg),

                _buildLabel('Title'),
                const SizedBox(height: AppSizes.sm),
                InputTextfield(
                  controller: _titleController,
                  hintText: 'Short summary',
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

                _buildLabel('Message'),
                const SizedBox(height: AppSizes.sm),
                InputTextfield(
                  controller: _messageController,
                  hintText: 'Write your message...',
                  icon: Icons.message_outlined,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  maxLength: _messageMax,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(_messageMax),
                  ],
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Please enter a message';
                    if (v.length > _messageMax) {
                      return 'Message must be $_messageMax characters or less';
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

