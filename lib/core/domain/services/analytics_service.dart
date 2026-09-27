abstract class AnalyticsService {
  Future<void> logScreenView({required String screenName});

  // Eventos de Autenticación
  Future<void> logSignUpStarted();
  Future<void> logSignUpCompleted({required String signUpMethod});
  Future<void> logLoginSuccess({required String loginMethod});
  Future<void> logLoginFailed({required String error});
}
