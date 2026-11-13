import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';

final clientSalesProvider = FutureProvider.autoDispose
    .family<List<SaleEntity>, int>((ref, clientId) {
      return ref.read(saleRepositoryProvider).getSalesByClient(clientId);
    });

final clientWorksProvider = FutureProvider.autoDispose
    .family<List<WorkEntity>, int>((ref, clientId) {
      return ref.read(workRepositoryProvider).getWorksByClient(clientId);
    });
