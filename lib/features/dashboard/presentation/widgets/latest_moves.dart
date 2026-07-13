import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/dashboard/presentation/widgets/recent_movement_card.dart';

class LatestMoves extends StatelessWidget {
  const LatestMoves({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("Últimos Movimientos", style: context.textTheme.titleMedium),
              Icon(Icons.history, color: AppColors.onBackground, size: 20),
            ],
          ),

          const SizedBox(height: 24),

          RecentMovementCard(
            title: 'ORD-088 marcada como Hecho.',
            subtitle: 'Stock actualizado: -150g PLA Negro',
            time: 'Hace 10 min.',
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),

          const SizedBox(height: 16),

          RecentMovementCard(
            title: 'Nueva venta registrada.',
            subtitle: 'Monto: \$2.500 (Mercado Pago)',
            time: 'Hace 45 min.',
            icon: Icons.point_of_sale_outlined,
            color: AppColors.primary,
          ),

          const SizedBox(height: 8),

          Divider(color: AppColors.outline),

          TextButton(
            onPressed: () {},
            child: Text(
              "Ver Historial Completo",
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
