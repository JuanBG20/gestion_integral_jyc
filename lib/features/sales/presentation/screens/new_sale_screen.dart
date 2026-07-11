import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_item_entity.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/payment_method_selector.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_items_list_section.dart';
import 'package:gestion_integral_jyc/features/sales/presentation/widgets/sale_summary_item_card.dart';
import 'package:go_router/go_router.dart';

class NewSaleScreen extends StatefulWidget {
  const NewSaleScreen({super.key});

  @override
  State<NewSaleScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewSaleScreen> {
  final _formKey = GlobalKey<FormState>();

  List<SaleItemEntity> _currentItems = [];

  double get _totalAmount =>
      _currentItems.fold(0, (sum, item) => sum + item.subtotal);

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Venta",
      subtitle: "Complete los detalles para registrar una nueva venta.",
      returnLabel: "Volver a Ventas",
      saveLabel: "Guardar Venta",
      maxWidth: 1200,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 24,
            runSpacing: 24,

            children: [
              SizedBox(
                width: constraints.maxWidth,

                child: LabeledDropdown(
                  label: "Cliente",
                  items: [],
                  onChanged: (newValue) {},
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,
                child: SaleItemsListSection(
                  onItemsChanged: (items) {
                    setState(() {
                      _currentItems = items;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
      sidePanel: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(4),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Resumen", style: context.textTheme.titleMedium),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            if (_currentItems.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "Aún no agregó productos.",
                  style: context.textTheme.bodySmall,
                ),
              ),
            ] else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    SaleSummaryItemCard(item: _currentItems[index]),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: _currentItems.length,
              ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Productos", style: context.textTheme.bodyMedium),
                Text(
                  "\$${_totalAmount.toStringAsFixed(2)}",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Total", style: context.textTheme.titleMedium),
                Text(
                  "\$${_totalAmount.toStringAsFixed(2)}",
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 16),

            PaymentMethodSelector(),
          ],
        ),
      ),
      onReturn: () {
        context.go('/sales');
      },
      onSave: () {},
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
