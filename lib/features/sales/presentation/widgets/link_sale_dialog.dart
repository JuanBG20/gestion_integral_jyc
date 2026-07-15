import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/mp_movement_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/mp_movement_provider.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';

class LinkSaleDialog extends ConsumerWidget {
  final MpMovementEntity movement;

  const LinkSaleDialog({super.key, required this.movement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos las ventas que ya tenés cargadas en el sistema
    final salesState = ref.watch(saleProvider);

    return AlertDialog(
      title: Text("Vincular a Venta", style: context.textTheme.titleLarge),
      content: SizedBox(
        width: 400,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Movimiento: \$${movement.amount} (${movement.date.ddMMyyyy})",
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text("Seleccioná la venta correspondiente:"),
            const SizedBox(height: 8),
            Expanded(
              child: salesState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text("Error al cargar ventas: $error")),
                data: (sales) {
                  if (sales.isEmpty) {
                    return const Center(
                      child: Text("No hay ventas registradas."),
                    );
                  }

                  return ListView.separated(
                    itemCount: sales.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      final isExactAmount = sale.finalAmount == movement.amount;

                      return ListTile(
                        title: Text("Venta #${sale.id} - ${sale.client.name}"),
                        subtitle: Text(sale.date.ddMMyyyy),
                        trailing: Text(
                          "\$${sale.finalAmount}",
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: isExactAmount
                                ? Colors.green
                                : AppColors.onBackground,
                            fontWeight: isExactAmount
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () async {
                          if (movement.id == null || sale.id == null) return;

                          try {
                            await ref
                                .read(mpMovementsProvider.notifier)
                                .linkToSale(movement.id!, sale.id!);
                            if (context.mounted) Navigator.of(context).pop();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancelar"),
        ),
      ],
    );
  }
}
