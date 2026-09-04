import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:gestion_integral_jyc/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl();
});

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<bool>>((ref) {
      return SubscriptionNotifier(ref.read(subscriptionRepositoryProvider));
    });

class SubscriptionNotifier extends StateNotifier<AsyncValue<bool>> {
  final SubscriptionRepository repository;

  final String entitlementId = 'Premium';

  SubscriptionNotifier(this.repository) : super(const AsyncValue.loading()) {
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    try {
      state = const AsyncValue.loading();
      final isPremium = await repository.isPremium(entitlementId);
      state = AsyncValue.data(isPremium);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> openPaywall() async {
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded(entitlementId);

      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
        state = const AsyncValue.data(true);
      }
    } catch (e) {
      print("Error o cancelación del paywall: $e");
    }
  }
}
