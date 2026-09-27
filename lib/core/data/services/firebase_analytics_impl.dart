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
}
