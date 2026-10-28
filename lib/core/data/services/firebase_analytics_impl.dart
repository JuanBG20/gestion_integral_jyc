import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:gestion_integral_jyc/core/domain/services/analytics_service.dart';

class FirebaseAnalyticsImpl implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  bool get _isAnalyticsSupported {
    if (kIsWeb) return true;
    return Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
  }

  @override
  Future<void> logScreenView({required String screenName}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logScreenView(screenName: screenName);
  }

  @override
  Future<void> logSignUpStarted() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'sign_up_started');
  }

  @override
  Future<void> logSignUpCompleted({required String signUpMethod}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  @override
  Future<void> logLoginSuccess({required String loginMethod}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  @override
  Future<void> logLoginFailed({required String error}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'login_failed',
      parameters: {'error_type': error},
    );
  }

  @override
  Future<void> logRawMaterialAdded() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'raw_material_added');
  }

  @override
  Future<void> logProductAdded({required int variantsNumber}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'product_added',
      parameters: {'number_of_variants': variantsNumber},
    );
  }

  @override
  Future<void> logScrapAdded() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'scrap_added');
  }

  @override
  Future<void> logPricesUpdated() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'prices_bulk_updated');
  }

  @override
  Future<void> logWorkCreated() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'work_created');
  }

  @override
  Future<void> logSaleCreated() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'sale_created');
  }

  @override
  Future<void> logInvoiceGenerated({required bool isManual}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'invoice_generated',
      parameters: {'is_manual': isManual},
    );
  }

  @override
  Future<void> logClientAdded() async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(name: 'client_added');
  }

  @override
  Future<void> logExpenseAdded({required String category}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'expense_added',
      parameters: {'category': category},
    );
  }

  @override
  Future<void> logExpenseTemplateAdded({required String category}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'expense_template_added',
      parameters: {'category': category},
    );
  }

  @override
  Future<void> logPaywallViewed({required String platform}) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.logEvent(
      name: 'paywall_viewed',
      parameters: {'platform': platform},
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (!_isAnalyticsSupported) return;
    await _analytics.setUserProperty(name: name, value: value);
  }
}
