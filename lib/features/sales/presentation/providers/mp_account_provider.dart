import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/sales/data/datasources/mp_account_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/sales/data/repositories/mp_account_repository_impl.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_account_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/repositories/mp_account_repository.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_movement_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final mpAccountDataSourceProvider = Provider<MpAccountRemoteDataSource>((ref) {
  return MpAccountRemoteDataSource(Supabase.instance.client);
});

final mpAccountRepositoryProvider = Provider<MpAccountRepository>((ref) {
  return MpAccountRepositoryImpl(ref.read(mpAccountDataSourceProvider));
});

final mpAccountProvider =
    StateNotifierProvider<MpAccountNotifier, AsyncValue<MpAccountEntity>>((
      ref,
    ) {
      ref.watch(authProvider.select((s) => s.user?.idAuth));
      return MpAccountNotifier(ref, ref.read(mpAccountRepositoryProvider));
    });

/// Premium y con una cuenta de MP conectada.
final isMpConnectedProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(subscriptionProvider).asData?.value ?? false;
  final isConnected =
      ref.watch(mpAccountProvider).asData?.value.isConnected ?? false;
  return isPremium && isConnected;
});

class MpAccountNotifier extends StateNotifier<AsyncValue<MpAccountEntity>> {
  final Ref ref;
  final MpAccountRepository repository;

  MpAccountNotifier(this.ref, this.repository)
    : super(const AsyncValue.loading()) {
    refresh();
  }

  Future<void> refresh() async {
    final wasConnected = state.asData?.value.isConnected;
    try {
      final status = await repository.getStatus();
      state = AsyncValue.data(status);

      if (wasConnected != null && wasConnected != status.isConnected) {
        ref.invalidate(mpMovementsProvider);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Abre el navegador para que el usuario autorice la app en Mercado Pago.
  Future<void> connect() async {
    final url = await repository.getAuthorizationUrl();
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      throw Exception('No se pudo abrir el navegador');
    }
  }

  Future<void> disconnect() async {
    await repository.disconnect();
    state = const AsyncValue.data(MpAccountEntity.disconnected());
    ref.invalidate(mpMovementsProvider);
  }
}
