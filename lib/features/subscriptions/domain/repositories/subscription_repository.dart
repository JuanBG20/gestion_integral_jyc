abstract class SubscriptionRepository {
  Future<void> init(String appleApiKey, String googleApiKey);
  Future<bool> isPremium(String entitlementId);
  Future<bool> restorePurchases(String entitlementId);
}
