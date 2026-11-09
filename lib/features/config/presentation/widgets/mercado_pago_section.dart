import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_account_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_account_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/utils/premium_gate.dart';
import 'package:intl/intl.dart';

class MercadoPagoSection extends ConsumerStatefulWidget {
  const MercadoPagoSection({super.key});

  @override
  ConsumerState<MercadoPagoSection> createState() => _MercadoPagoSectionState();
}

class _MercadoPagoSectionState extends ConsumerState<MercadoPagoSection> {
  late final AppLifecycleListener _lifecycleListener;
  bool _isWorking = false;

  @override
  void initState() {
    super.initState();
    // Al volver del navegador, refrescar el estado de la conexión.
    _lifecycleListener = AppLifecycleListener(
      onResume: () => ref.read(mpAccountProvider.notifier).refresh(),
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _connect() {
    PremiumGate.guard(context, ref, () async {
      setState(() => _isWorking = true);
      try {
        await ref.read(mpAccountProvider.notifier).connect();
      } catch (e) {
        _showError(e);
      } finally {
        if (mounted) setState(() => _isWorking = false);
      }
    });
  }

  Future<void> _disconnect() async {
    final confirmed = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('¿Desconectar Mercado Pago?'),
        content: const Text(
          'Se dejarán de sincronizar los cobros nuevos. Los movimientos ya importados se conservan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Desconectar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isWorking = true);
    try {
      await ref.read(mpAccountProvider.notifier).disconnect();
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(mpAccountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mercado Pago", style: context.textTheme.titleMedium),

        const SizedBox(height: 4),

        Text(
          "Conectá tu cuenta para traer automáticamente los cobros y vincularlos a tus ventas.",
          style: context.textTheme.bodySmall,
        ),

        Divider(color: AppColors.outline),

        accountState.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.error_outline, color: AppColors.error),
            title: const Text('No se pudo obtener el estado de la conexión'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reintentar',
              onPressed: () => ref.read(mpAccountProvider.notifier).refresh(),
            ),
          ),
          data: _buildStatus,
        ),
      ],
    );
  }

  Widget _buildStatus(MpAccountEntity account) {
    if (!account.isConnected) {
      return _statusTile(
        icon: Icons.link_off,
        iconColor: AppColors.onBackground,
        title: 'Sin cuenta conectada',
        action: ElevatedButton.icon(
          onPressed: _isWorking ? null : _connect,
          icon: const Icon(Icons.link),
          label: const Text('Conectar Mercado Pago'),
        ),
      );
    }

    if (account.needsReconnection) {
      return _statusTile(
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
        title: 'Hay que volver a conectar ${account.nickname ?? 'tu cuenta'}',
        subtitle:
            'Mercado Pago dejó de aceptar el permiso. Los cobros nuevos no se están sincronizando.',
        action: ElevatedButton.icon(
          onPressed: _isWorking ? null : _connect,
          icon: const Icon(Icons.refresh),
          label: const Text('Reconectar'),
        ),
      );
    }

    final lastSync = account.lastSync != null
        ? 'Última sincronización: ${DateFormat('dd/MM/yyyy HH:mm').format(account.lastSync!)}'
        : 'Todavía no se sincronizó. Los cobros aparecerán en unos minutos.';

    return _statusTile(
      icon: Icons.check_circle_outline,
      iconColor: AppColors.primary,
      title:
          'Conectada${account.nickname != null ? ': ${account.nickname}' : ''}',
      subtitle: lastSync,
      action: TextButton(
        onPressed: _isWorking ? null : _disconnect,
        child: Text('Desconectar', style: TextStyle(color: AppColors.error)),
      ),
    );
  }

  Widget _statusTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget action,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
        ),
        Align(alignment: Alignment.centerRight, child: action),
      ],
    );
  }
}
