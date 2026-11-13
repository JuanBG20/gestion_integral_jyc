import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/month_selector.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_account_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_movement_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/link_sale_dialog.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/view_linked_sales_dialog.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/providers/subscription_provider.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/widgets/premium_locked_feature.dart';
import 'package:go_router/go_router.dart';

class MpMovements extends ConsumerWidget {
  const MpMovements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(subscriptionProvider).asData?.value ?? false;
    final accountState = ref.watch(mpAccountProvider);
    final showMonthSelector =
        isPremium && (accountState.asData?.value.isConnected ?? false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          _buildHeader(context, ref, showMonthSelector: showMonthSelector),

          const SizedBox(height: 16),

          if (!isPremium)
            const PremiumLockedFeature(
              icon: Icons.sync,
              title: 'Movimientos de Mercado Pago',
              description:
                  'Traé automáticamente tus cobros de Mercado Pago y vinculalos a tus ventas. '
                  'Disponible en el plan Premium',
            )
          else
            accountState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Text('Error al cargar la conexión con Mercado Pago: $err'),
              data: (account) {
                if (!account.isConnected) {
                  return _buildConnectPrompt(context);
                }

                final movementsState = ref.watch(mpMovementsProvider);
                return movementsState.when(
                  data: (movements) =>
                      _buildMovementsList(context, ref, movements),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text('Error al cargar movimientos: $err'),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref, {
    required bool showMonthSelector,
  }) {
    return Row(
      children: [
        Icon(Icons.sync, color: AppColors.primary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            "Movimientos Mercado Pago",
            style: context.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        if (showMonthSelector) ...[
          const SizedBox(width: 8),
          MonthSelector(
            selected: ref.watch(mpMovementMonthProvider),
            onChanged: (month) =>
                ref.read(mpMovementMonthProvider.notifier).state = month,
          ),
        ],

        /* Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(2),
          ),

          child: Text(
            "Última act: Hace 2 min",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.onBackground,
            ),
          ),
        ),

        const SizedBox(width: 8), 
        IconButton(
          icon: const Icon(Icons.refresh, size: 20),
          onPressed: () {
            ref.read(mpMovementsProvider.notifier).fetchMovements();
          },
          tooltip: 'Actualizar movimientos',
        ),*/
      ],
    );
  }

  Widget _buildConnectPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            'Conectá tu cuenta de Mercado Pago para ver tus cobros acá.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => context.go('/config'),
            icon: const Icon(Icons.link),
            label: const Text('Conectar Mercado Pago'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementsList(
    BuildContext context,
    WidgetRef ref,
    List<MpMovementEntity> movements,
  ) {
    if (movements.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text("No hay movimientos en este mes.")),
      );
    }

    return _IncrementalList(
      key: ValueKey(ref.watch(mpMovementMonthProvider)),
      itemCount: movements.length,
      itemBuilder: (context, index) =>
          _buildMovementItem(context, ref, movements[index]),
    );
  }

  Widget _buildMovementItem(
    BuildContext context,
    WidgetRef ref,
    MpMovementEntity movement,
  ) {
    final (icon, title) = _getPaymentMethodDetails(movement.paymentMethod);
    final isLinked = movement.saleIds != null && movement.saleIds!.isNotEmpty;
    final isRoot = ref.watch(isRootProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
        color: isLinked ? AppColors.primary.withValues(alpha: 0.1) : null,
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: context.textTheme.bodyMedium),
                Text(
                  movement.date.ddMMyyyy,
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Text("\$${movement.amount}"),

          const SizedBox(width: 16),

          SizedBox(
            width: 40,
            child: AppActionMenu(
              items: [
                if (isLinked)
                  const AppActionMenuItem(
                    value: 'view_sales',
                    label: 'Ver ventas asociadas',
                  ),

                if (!isLinked && isRoot)
                  const AppActionMenuItem(
                    value: 'bill',
                    label: 'Facturar Rápido',
                  ),

                const AppActionMenuItem(
                  value: 'link',
                  label: 'Vincular a Venta',
                ),
              ],
              onSelected: (value) =>
                  _handleMpMovementAction(context, ref, value, movement),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String) _getPaymentMethodDetails(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.qr:
        return (Icons.qr_code_scanner, "Cobro QR");
      case PaymentMethod.tarjeta:
        return (Icons.credit_card, "Cobro Tarjeta");
      case PaymentMethod.transferencia:
        return (Icons.account_balance, "Transferencia");
      case PaymentMethod.efectivo:
        return (Icons.payments, "Efectivo (Punto de Pago)");
    }
  }

  void _handleMpMovementAction(
    BuildContext context,
    WidgetRef ref,
    String action,
    MpMovementEntity movement,
  ) {
    switch (action) {
      case 'bill':
        final clients = ref
            .read(clientProvider)
            .maybeWhen(
              data: (clients) => clients,
              orElse: () => <ClientEntity>[],
            );
        ClientEntity? consumidorFinal;
        for (final c in clients) {
          if (c.name == 'Consumidor' && c.lastName == 'Final') {
            consumidorFinal = c;
            break;
          }
        }

        if (consumidorFinal == null || consumidorFinal.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se encontró el cliente "Consumidor Final".'),
            ),
          );
          return;
        }

        final quickSale = SaleEntity(
          paymentMethod: movement.paymentMethod,
          date: movement.date,
          finalAmount: movement.amount,
          subtotal: movement.amount,
          client: consumidorFinal,
          items: [
            SaleItemEntity(
              quantity: 1,
              unitPrice: movement.amount,
              description: 'Movimiento MP',
            ),
          ],
          discounts: [],
          isPaid: true,
        );

        context.push(
          '/sales/detail/bill?mpMovementId=${movement.id}',
          extra: quickSale,
        );
      case 'link':
        showDialog(
          context: context,
          builder: (context) => LinkSaleDialog(movement: movement),
        );
      case 'view_sales':
        if (movement.saleIds != null && movement.saleIds!.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) =>
                ViewLinkedSalesDialog(saleIds: movement.saleIds!),
          );
        }
    }
  }
}

class _IncrementalList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const _IncrementalList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  static const initialCount = 5;
  static const step = 10;

  @override
  State<_IncrementalList> createState() => _IncrementalListState();
}

class _IncrementalListState extends State<_IncrementalList> {
  int _visible = _IncrementalList.initialCount;

  @override
  Widget build(BuildContext context) {
    final shown = widget.itemCount < _visible ? widget.itemCount : _visible;
    final remaining = widget.itemCount - shown;

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shown,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: widget.itemBuilder,
        ),

        if (remaining > 0) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => setState(() => _visible += _IncrementalList.step),
            icon: const Icon(Icons.expand_more),
            label: Text("Mostrar más ($remaining restantes)"),
          ),
        ],
      ],
    );
  }
}
