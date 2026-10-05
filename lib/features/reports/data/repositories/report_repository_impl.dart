import 'package:gestion_integral_jyc/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/reports/data/models/report_dashboard_model.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';
import 'package:gestion_integral_jyc/features/reports/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReportDashboardEntity> getReportMetrics() async {
    final rawData = await remoteDataSource.fetchDashboardMetrics();
    return ReportDashboardModel.fromJson(rawData);
  }
}
