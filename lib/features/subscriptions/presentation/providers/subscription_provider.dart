import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:gestion_integral_jyc/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl();
});

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, AsyncValue<bool>>((ref) {
      return SubscriptionNotifier(
        ref.read(subscriptionRepositoryProvider),
        ref,
      );
    });

class SubscriptionNotifier extends StateNotifier<AsyncValue<bool>> {
  final SubscriptionRepository repository;
  final Ref ref;

  final String entitlementId = 'Premium';

  SubscriptionNotifier(this.repository, this.ref)
    : super(const AsyncValue.loading()) {
    checkPremiumStatus();
  }

  Future<void> checkPremiumStatus() async {
    try {
      state = const AsyncValue.loading();

      if (Platform.isWindows) {
        final authState = ref.read(authProvider);
        final user = authState.user;

        if (user == null) {
          state = const AsyncValue.data(false);
          return;
        }

        bool isPremiumLocal = user.isPremium;

        if (isPremiumLocal && user.premiumExpiresAt != null) {
          final nowUtc = DateTime.now().toUtc();
          if (nowUtc.isAfter(user.premiumExpiresAt!)) {
            isPremiumLocal = false;
          }
        }

        state = AsyncValue.data(isPremiumLocal);
      } else {
        final isPremiumRc = await repository.isPremium(entitlementId);
        state = AsyncValue.data(isPremiumRc);
      }
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
