import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/components/app_loading_indicator.dart';
import '../../../../app/components/empty_state.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/components/error_widget.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/snackbar_service.dart';
import '../providers/address_events.dart';
import '../providers/address_notifier.dart';
import '../widgets/address_card.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for profile events
    ref.listen<AddressUiEvent?>(addressUiEventsProvider, (prev, next) {
      if (next == null) return;
      final snackbar = ref.read(snackbarServiceProvider);
      if (next is AddressFailure) {
        snackbar.showError(next.failure);
      } else if (next is AddressCreated) {
        snackbar.showSuccess(next.message);
      } else if (next is AddressDeleted) {
        snackbar.showSuccess(next.message);
      } else if (next is AddressUpdated) {
        snackbar.showSuccess(next.message);
      }
      ref.read(addressUiEventsProvider.notifier).clear();
    });

    final addressState = ref.watch(addressProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Your Addresses'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteName.createOrUpdateAddress),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Address'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 32,
        ),
        child: addressState.when(
          data: (addresses) {
            if (addresses.isEmpty) {
              return EmptyState(
                icon: Icons.location_on_outlined,
                title: 'No addresses found',
                subtitle: 'Add your first address to get started',
                actionText: 'Add Address',
                onAction: () => context.push(RouteName.createOrUpdateAddress),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.defaultMaxScreenWidth),
                child: ListView.builder(
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    return AddressCard(address: addresses[index]);
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorWidgett(
            icon: Icons.error_outline,
            title: 'We could not access your saved addresses.',
            failure: error is Failure
                ? error
                : Failure.unexpected(message: error.toString()),
            onRetry: () => ref.refresh(addressProvider.future),
          ),
          loading: () => const AppLoadingIndicator(),
        ),
      ),
    );
  }
}
