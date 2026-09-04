import 'dart:io';

import 'package:gestion_integral_jyc/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  @override
  Future<void> init(String appleApiKey, String googleApiKey) async {
    /* await Purchases.setLogLevel(LogLevel.debug); // Consola */

    PurchasesConfiguration? configuration;

    // TODO: Windows
    if (Platform.isIOS || Platform.isMacOS) {
      configuration = PurchasesConfiguration(appleApiKey);
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(googleApiKey);
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  @override
  Future<bool> isPremium(String entitlementId) async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all[entitlementId]?.isActive == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchases(String entitlementId) async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all[entitlementId]?.isActive == true;
    } catch (e) {
      return false;
    }
  }
}
