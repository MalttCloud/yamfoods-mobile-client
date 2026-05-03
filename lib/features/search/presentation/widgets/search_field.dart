import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../responsive.dart';
import '../providers/search_providers.dart';

/// Modern search field with debouncing.
///
/// Automatically updates the search filter after user stops typing for 500ms.
class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(searchFiltersProvider.notifier)
          .updateSearch(value.isEmpty ? null : value);
    });
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchFiltersProvider.notifier).updateSearch(null);
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);
    final hasSearch = filters.search != null && filters.search!.isNotEmpty;

    return Center(
      child: ConstrainedBox(
        constraints: context.isTablet ? const BoxConstraints(maxWidth: 600) : const BoxConstraints(maxWidth: double.infinity) ,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            onChanged: _onSearchChanged,
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.txtPrimary),
            decoration: InputDecoration(
              hintText: 'Search for food...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.txtSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              suffixIcon: hasSearch
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.txtSecondary.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.md,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
