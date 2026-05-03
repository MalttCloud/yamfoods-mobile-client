import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/components/custom_button.dart';
import '../../../../app/components/input_textfield.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/constants/api_urls.dart';
import '../../../../core/utils/image_url_builder.dart';
import '../../../auth/domain/entities/user.dart';
import '../providers/profile_events.dart';
import '../providers/profile_notifier.dart';
import '../providers/profile_providers.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  final User user;
  const UpdateProfileScreen({super.key, required this.user});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            imageFile: _pickedImage,
          );
    }
  }

  String? _buildImageUrl() {
    if (widget.user.imageUrl == null || widget.user.imageUrl!.isEmpty) {
      return null;
    }
    return ImageUrlBuilder.build(
      baseUrl: ApiUrls.getClientImageBaseUrl(),
      imagePath: widget.user.imageUrl!,
    );
  }

  Widget _buildAvatarContent(String? imageUrl) {
    if (_pickedImage != null) {
      return Image.file(_pickedImage!, fit: BoxFit.cover);
    }
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => _avatarPlaceholder(),
        errorWidget: (_, _, _) => _avatarPlaceholder(),
      );
    }
    return _avatarPlaceholder();
  }

  Widget _avatarPlaceholder() {
    return Center(
      child: Icon(
        Icons.person_rounded,
        size: 50,
        color: AppColors.primary.withValues(alpha: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for profile events
    ref.listen<ProfileUiEvent?>(profileUiEventsProvider, (prev, next) {
      if (next == null) return;
      if (next is ProfileUpdated) {
        ref.invalidate(userProfileProvider);
        context.pop();
      }
      ref.read(profileUiEventsProvider.notifier).clear();
    });

    final isLoading = ref.watch(profileProvider);
    final imageUrl = _buildImageUrl();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Update Profile'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.lg),
        child:
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.authScreensMaxWidth),
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
                            // Image Picker
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 3,
                                      ),
                                      color:
                                          _pickedImage == null && imageUrl == null
                                          ? AppColors.primary.withValues(alpha: 0.1)
                                          : null,
                                    ),
                                    child: ClipOval(
                                      child: _buildAvatarContent(imageUrl),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSizes.lg),
                
                            // Name Field
                            _buildLabel('Full Name'),
                            const SizedBox(height: AppSizes.sm),
                            InputTextfield(
                              controller: _nameController,
                              hintText: 'Enter your full name',
                              icon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your name';
                                }
                                if (value.trim().length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                
                            const SizedBox(height: AppSizes.lg),
                
                            // Email Field
                            _buildLabel('Email Address'),
                            const SizedBox(height: AppSizes.sm),
                            InputTextfield(
                              controller: _emailController,
                              hintText: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value.trim())) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                
                            const SizedBox(height: AppSizes.xl),
                
                            // Submit Button
                            CustomButton(
                              text: 'Save Change',
                              onPressed: _handleSubmit,
                              isLoading: isLoading,
                              loadingText: 'Saving change...',
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),
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
