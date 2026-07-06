import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../map/data/models/forward_geocoding_model.dart';
import '../../../map/presentation/providers/map_provider.dart';

class AddressSearchField extends ConsumerStatefulWidget {
  final void Function(FGAddressModel result) onResultSelected;

  const AddressSearchField({
    super.key,
    required this.onResultSelected,
  });

  @override
  ConsumerState<AddressSearchField> createState() => _AddressSearchFieldState();
}

class _AddressSearchFieldState extends ConsumerState<AddressSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  String _query = '';

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
  }

  void _selectResult(FGAddressModel result) {
    _focusNode.unfocus();
    _controller.text = result.displayName;
    setState(() => _query = '');
    widget.onResultSelected(result);
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = _query.length >= 2
        ? ref.watch(addressSearchResultsProvider(_query))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
            focusNode: _focusNode,
            onChanged: _onSearchChanged,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.txtPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Search for a delivery location',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.txtSecondary.withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.primary,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: AppColors.txtSecondary.withValues(alpha: 0.6),
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
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radius),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.md,
              ),
            ),
          ),
        ),
        if (searchAsync != null && _focusNode.hasFocus)
          _SearchResultsList(
            searchAsync: searchAsync,
            onResultSelected: _selectResult,
          ),
      ],
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final AsyncValue<List<FGAddressModel>> searchAsync;
  final void Function(FGAddressModel result) onResultSelected;

  const _SearchResultsList({
    required this.searchAsync,
    required this.onResultSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.sm),
      constraints: const BoxConstraints(maxHeight: 220),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: searchAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSizes.lg),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Text(
            'Could not load search results.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.txtSecondary,
            ),
          ),
        ),
        data: (results) {
          if (results.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Text(
                'No places found.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.txtSecondary,
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: AppColors.grey.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                title: Text(
                  result.displayName,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => onResultSelected(result),
              );
            },
          );
        },
      ),
    );
  }
}
