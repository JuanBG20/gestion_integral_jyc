import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/screen_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/price_preview_provider.dart';
import 'package:go_router/go_router.dart';

class PriceUpdatePreviewScreen extends ConsumerStatefulWidget {
  const PriceUpdatePreviewScreen({super.key});

  @override
  ConsumerState<PriceUpdatePreviewScreen> createState() =>
      _PriceUpdatePreviewScreenState();
}

class _PriceUpdatePreviewScreenState
    extends ConsumerState<PriceUpdatePreviewScreen> {
  final Set<int> _selectedIds = {};

  static const _productColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
    AppTableColumn(label: "Precio Venta Sugerido", flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final pricePreviewState = ref.watch(pricePreviewProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ScreenHeader(
              title: "Actualización de Precios",
              subtitle:
                  "Revisá los nuevos precios sugeridos, calculados a partir de los costos de materiales.",
              buttonLabel: "Confirmar Cambios",
              onPressed: () {
                if (_selectedIds.isEmpty) return;

                ref
                    .read(pricePreviewProvider.notifier)
                    .confirmNewPrices(_selectedIds.toList());

                setState(() {
                  _selectedIds.clear();
                });
              },
              hasSecondaryButton: true,
              secondaryButtonLabel: "Cancelar",
              secondaryButtonIcon: Icons.close,
              onPressedSecundary: () => context.pop(),
            ),

            const SizedBox(height: 24),

            pricePreviewState.when(
              data: (pricePreviews) {
                if (pricePreviews.isEmpty) {
                  return const Center(
                    child: Text("No hay precios de venta sugeridos."),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.checklist),
                      onPressed: () {
                        setState(() {
                          if (_selectedIds.length == pricePreviews.length) {
                            _selectedIds.clear();
                          } else {
                            _selectedIds.addAll(
                              pricePreviews.map((p) => p.variantId),
                            );
                          }
                        });
                      },
                      label: Text(
                        _selectedIds.length == pricePreviews.length
                            ? "Deseleccionar Todos"
                            : "Seleccionar Todos",
                      ),
                    ),

                    const SizedBox(height: 8),

                    AppTableShell(
                      shrinkWrap: true,
                      header: const AppTableHeader(columns: _productColumns),
                      rows: pricePreviews.map((pricePreview) {
                        final isSelected = _selectedIds.contains(
                          pricePreview.variantId,
                        );

                        return AppTableRow(
                          trailingWidth: 40,
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedIds.add(pricePreview.variantId);
                                } else {
                                  _selectedIds.remove(pricePreview.variantId);
                                }
                              });
                            },
                          ),

                          cells: [
                            AppTableCell.text(pricePreview.variantSku, flex: 2),
                            AppTableCell.text(
                              pricePreview.description,
                              flex: 3,
                            ),
                            AppTableCell.text(
                              '\$${pricePreview.costPrice.toStringAsFixed(2)}',
                              flex: 2,
                            ),
                            AppTableCell.text(
                              '\$${pricePreview.actualSalePrice.toStringAsFixed(2)}',
                              flex: 2,
                            ),
                            AppTableCell.text(
                              '\$${pricePreview.suggestedSalePrice.toStringAsFixed(2)}',
                              flex: 2,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text("Error: $e")),
            ),
          ],
        ),
      ),
    );
  }
}
