abstract class AnalyticsService {
  Future<void> logScreenView({required String screenName});
  Future<void> setUserProperty({required String name, required String value});

  // Eventos de Autenticación
  Future<void> logSignUpStarted();
  Future<void> logSignUpCompleted({required String signUpMethod});
  Future<void> logLoginSuccess({required String loginMethod});
  Future<void> logLoginFailed({required String error});

  // Eventos de Creación
  // Inventario
  Future<void> logRawMaterialAdded();
  Future<void> logProductAdded({required int variantsNumber});
  Future<void> logScrapAdded();
  Future<void> logPricesUpdated();

  // Producción
  Future<void> logWorkCreated();

  // Ventas
  Future<void> logSaleCreated();
  Future<void> logInvoiceGenerated({required bool isManual});

  // Clientes
  Future<void> logClientAdded();

  // Gastos
  Future<void> logExpenseAdded({required String category});
  Future<void> logExpenseTemplateAdded({required String category});

  // Suscripciones
  Future<void> logPaywallViewed({required String platform});
}
