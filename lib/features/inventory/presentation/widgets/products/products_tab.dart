import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/models/product_group_ui.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/products/expandable_table_row.dart';

class ProductsTab extends StatelessWidget {
  final List<ProductGroupUi> products;
  final bool isAdmin;

  const ProductsTab({super.key, required this.isAdmin, required this.products});

  static const _productColumns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Descripción", flex: 3),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Categoría > Subcategoría", flex: 3),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return AppTableShell(
      header: const AppTableHeader(
        columns: _productColumns,
        padding: EdgeInsets.only(top: 24, right: 24, bottom: 24, left: 60),
      ),
      rows: products
          .map(
            (product) => ExpandableTableRow(product: product, isAdmin: isAdmin),
          )
          .toList(),
    );
  }
}
