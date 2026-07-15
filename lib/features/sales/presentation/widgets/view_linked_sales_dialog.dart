import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/providers/sale_provider.dart';
import 'package:go_router/go_router.dart';

class ViewLinkedSalesDialog extends ConsumerWidget {
  final List<int> saleIds;

  const ViewLinkedSalesDialog({super.key, required this.saleIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(saleProvider);

    return AlertDialog(
      title: Text("Ventas Asociadas", style: context.textTheme.titleLarge),
      content: SizedBox(
        width: 350,
        child: salesState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text("Error: $err"),
          data: (allSales) {
            final linkedSales = allSales
                .where((s) => saleIds.contains(s.id))
                .toList();

            if (linkedSales.isEmpty) {
              return const Text("No se encontraron detalles de estas ventas.");
            }

            return ListView.separated(
              shrinkWrap: true,
              itemCount: linkedSales.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final sale = linkedSales[index];
                return ListTile(
                  title: Text(
                    "Venta #${sale.id}",
                    style: context.textTheme.bodyMedium,
                  ),
                  subtitle: Text(sale.date.ddMMyyyy),
                  trailing: Text(
                    "\$${sale.finalAmount.toStringAsFixed(2)}",
                    style: context.textTheme.bodyMedium,
                  ),
                  onTap: () {
                    context.go('/sales/detail', extra: sale);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cerrar"),
        ),
      ],
    );
  }
}
