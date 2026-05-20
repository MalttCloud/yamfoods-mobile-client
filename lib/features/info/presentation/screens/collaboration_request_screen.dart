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
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../providers/info_providers.dart';
import '../widgets/collaboration_request_success_dialog.dart';

class CollaborationRequestScreen extends ConsumerStatefulWidget {
  const CollaborationRequestScreen({super.key});

  @override
  ConsumerState<CollaborationRequestScreen> createState() =>
      _CollaborationRequestScreenState();
}

class _CollaborationRequestScreenState
    extends ConsumerState<CollaborationRequestScreen> {
  static const int _nameMax = 50;
  static const int _phoneMax = 20;
  static const int _emailMax = 50;
  static const int _organizationMax = 100;
  static const int _websiteMax = 150;
  static const int _titleMax = 150;
  static const int _proposalMax = 5000;

  static final RegExp _emailPattern = RegExp(
    r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
  );

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _organizationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _titleController = TextEditingController();
  final _proposalController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _showSuccessDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const CollaborationRequestSuccessDialog(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _organizationController.dispose();
    _websiteController.dispose();
    _titleController.dispose();
    _proposalController.dispose();
    super.dispose();
  }

  String? _optionalEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (v.length > _emailMax) {
      return 'Email must be $_emailMax characters or less';
    }
    if (!_emailPattern.hasMatch(v)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _optionalWebsite(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return null;
    if (v.length > _websiteMax) {
      return 'Website must be $_websiteMax characters or less';
    }
    final raw = v.startsWith('http://') || v.startsWith('https://')
        ? v
        : 'https://$v';
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'Please enter a valid website URL';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isSubmitting = true);
    final snackbar = ref.read(snackbarServiceProvider);

    final emailTrim = _emailController.text.trim();
    final orgTrim = _organizationController.text.trim();
    final webTrim = _websiteController.text.trim();

    try {
      final params = (
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: emailTrim.isEmpty ? null : emailTrim,
        organization: orgTrim.isEmpty ? null : orgTrim,
        website: webTrim.isEmpty ? null : webTrim,
        title: _titleController.text.trim(),
        proposal: _proposalController.text.trim(),
      );

      await ref.read(submitCollaborationRequestProvider(params).future);
      if (!mounted) return;

      setState(() => _isSubmitting = false);
      await WidgetsBinding.instance.endOfFrame;

      await _showSuccessDialog();
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
      appBar: const CustomAppBar(title: 'Collaboration request'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.defaultMaxScreenWidth,
            ),
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
                      'Work with Noodo Bakers',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tell us about your organization and what you have in mind.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.txtSecondary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Full name', isRequired: true),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _nameController,
                      hintText: 'Your name',
                      icon: Icons.person_outline_rounded,
                      maxLength: _nameMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_nameMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Please enter your name';
                        if (v.length > _nameMax) {
                          return 'Name must be $_nameMax characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Phone', isRequired: true),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _phoneController,
                      hintText: '+251…',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      maxLength: _phoneMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_phoneMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Please enter a phone number';
                        if (v.length > _phoneMax) {
                          return 'Phone must be $_phoneMax characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Email'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _emailController,
                      hintText: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: _emailMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_emailMax),
                      ],
                      validator: _optionalEmail,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Organization'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _organizationController,
                      hintText: 'Company or group name',
                      icon: Icons.apartment_outlined,
                      maxLength: _organizationMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_organizationMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return null;
                        if (v.length > _organizationMax) {
                          return 'Organization must be $_organizationMax '
                              'characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Website'),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _websiteController,
                      hintText: 'https://example.com',
                      icon: Icons.link_rounded,
                      keyboardType: TextInputType.url,
                      maxLength: _websiteMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_websiteMax),
                      ],
                      validator: _optionalWebsite,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _buildLabel('Proposal title', isRequired: true),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _titleController,
                      hintText: 'Short subject line',
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
                    _buildLabel('Proposal details', isRequired: true),
                    const SizedBox(height: AppSizes.sm),
                    InputTextfield(
                      controller: _proposalController,
                      hintText: 'Describe your idea, goals, and how we could work together…',
                      icon: Icons.description_outlined,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      maxLength: _proposalMax,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(_proposalMax),
                      ],
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) {
                          return 'Please describe your proposal';
                        }
                        if (v.length > _proposalMax) {
                          return 'Proposal must be $_proposalMax characters or less';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                    CustomButton(
                      text: 'Submit request',
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

  Widget _buildLabel(String text, {bool isRequired = false}) {
    final baseStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.txtSecondary.withValues(alpha: 0.8),
    );
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: text),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: baseStyle.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
