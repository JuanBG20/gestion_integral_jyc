import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class MpMovements extends StatelessWidget {
  const MpMovements({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
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
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(4),
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

                  child: Icon(Icons.qr_code_scanner, color: AppColors.primary),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Cobro QR", style: context.textTheme.bodyMedium),
                      Text("17/05/2026", style: context.textTheme.bodySmall),
                    ],
                  ),
                ),

                Text("\$24500"),

                const SizedBox(width: 16),

                SizedBox(
                  width: 40,
                  child: AppActionMenu(
                    items: [
                      const AppActionMenuItem(
                        value: 'invoice',
                        label: 'Facturar',
                      ),
                      const AppActionMenuItem(
                        value: 'link',
                        label: 'Vincular a Venta',
                      ),
                    ],
                    onSelected: (value) =>
                        _handleMpMovementAction(context, value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMpMovementAction(BuildContext context, String action) {
    switch (action) {
      case 'invoice':
      // TODO: Facturar MP
      case 'link':
      // TODO: Vincular Venta a MP
    }
  }
}
