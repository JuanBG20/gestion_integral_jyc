import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/reports/data/models/report_dashboard_model.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';
import 'package:gestion_integral_jyc/features/reports/domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReportDashboardEntity> getReportMetrics(DateTime month) async {
    final rawData = await remoteDataSource.fetchDashboardMetrics(
      from: month.monthStart,
      to: month.nextMonthStart,
    );
    return ReportDashboardModel.fromJson(rawData);
  }
}
