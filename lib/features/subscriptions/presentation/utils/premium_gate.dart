import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/analytics_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:go_router/go_router.dart';

class PremiumGate {
  static void guard(BuildContext context, WidgetRef ref, VoidCallback action) {
    final isPremium = ref.read(subscriptionProvider).asData?.value ?? false;

    if (isPremium) {
      action();
      return;
    }

    final analytics = ref.read(analyticsProvider);

    final platformName = kIsWeb ? 'web' : Platform.operatingSystem;
    final bool isMobileNative =
        !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    if (!isMobileNative) {
      analytics.logPaywallViewed(platform: platformName);
      context.go('/subscriptions/windows');
      return;
    }

    analytics.logPaywallViewed(platform: platformName);
    ref.read(subscriptionProvider.notifier).openPaywall();
  }
}
