import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/reports/data/repositories/report_repository_impl.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/report_dashboard_entity.dart';
import 'package:gestion_integral_jyc/features/reports/domain/repositories/report_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final reportDataSourceProvider = Provider<ReportRemoteDataSource>((ref) {
  return ReportRemoteDataSource(Supabase.instance.client);
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final dataSource = ref.read(reportDataSourceProvider);
  return ReportRepositoryImpl(dataSource);
});

final reportMetricsProvider = FutureProvider.autoDispose<ReportDashboardEntity>(
  (ref) async {
    final repository = ref.read(reportRepositoryProvider);
    return await repository.getReportMetrics();
  },
);
