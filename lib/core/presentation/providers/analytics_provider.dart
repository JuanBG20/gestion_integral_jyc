import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/data/services/firebase_analytics_impl.dart';
import 'package:gestion_integral_jyc/core/domain/services/analytics_service.dart';

final analyticsProvider = Provider<AnalyticsService>((ref) {
  return FirebaseAnalyticsImpl();
});
