import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';

abstract class ReportRepository {
  Future<ReportDashboardEntity> getReportMetrics();
}
