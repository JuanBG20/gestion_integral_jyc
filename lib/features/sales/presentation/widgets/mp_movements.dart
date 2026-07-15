import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_movement_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/link_sale_dialog.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/view_linked_sales_dialog.dart';

class MpMovements extends ConsumerWidget {
  const MpMovements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsState = ref.watch(mpMovementsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          _buildHeader(context, ref),

          const SizedBox(height: 16),

          movementsState.when(
            data: (movements) => _buildMovementsList(context, movements),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error al cargar movimientos: $err'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Icon(Icons.sync, color: AppColors.primary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            "Movimientos Mercado Pago",
            style: context.textTheme.titleMedium,
          ),
        ),

        Container(
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
        ),
      ],
    );
  }

  Widget _buildMovementsList(
    BuildContext context,
    List<MpMovementEntity> movements,
  ) {
    if (movements.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text("No hay movimientos recientes.")),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movements.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final movement = movements[index];
        return _buildMovementItem(context, movement);
      },
    );
  }

  Widget _buildMovementItem(BuildContext context, MpMovementEntity movement) {
    final (icon, title) = _getPaymentMethodDetails(movement.paymentMethod);
    final isLinked = movement.saleIds != null && movement.saleIds!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
        color: isLinked ? AppColors.surface.withValues(alpha: 0.5) : null,
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
                  AppActionMenuItem(
                    value: 'view_sales',
                    label: 'Ver ${movement.saleIds!.length} venta(s)',
                  ),

                if (!isLinked)
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
                  _handleMpMovementAction(context, value, movement),
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
    String action,
    MpMovementEntity movement,
  ) {
    switch (action) {
      case 'bill':
      /* final quickSale = SaleEntity(
          paymentMethod: movement.paymentMethod,
          date: movement.date,
          finalAmount: movement.amount,
          client: ,
          items: [],
        ); */
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
