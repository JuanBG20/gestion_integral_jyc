import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_header.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_row.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_shell.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/variant_mock_data.dart';

class VariantsTableSection extends StatefulWidget {
  const VariantsTableSection({super.key});

  @override
  State<VariantsTableSection> createState() => _VariantsTableSectionState();
}

class _VariantsTableSectionState extends State<VariantsTableSection> {
  final List<VariantMockData> _variants = [];

  final _skuController = TextEditingController();
  final _colorController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController();
  final _costController = TextEditingController();
  final _saleController = TextEditingController();

  static const _columns = [
    AppTableColumn(label: "SKU", flex: 2),
    AppTableColumn(label: "Color", flex: 2),
    AppTableColumn(label: "Talle", flex: 2),
    AppTableColumn(label: "Stock", flex: 1),
    AppTableColumn(label: "Precio Costo", flex: 2),
    AppTableColumn(label: "Precio Venta", flex: 2),
  ];

  void _addVariant() {
    if (_skuController.text.isEmpty) return;

    setState(() {
      _variants.add(
        VariantMockData(
          sku: _skuController.text,
          color: _colorController.text,
          size: _sizeController.text.isEmpty ? '-' : _sizeController.text,
          stock: _stockController.text.isEmpty ? '0' : _stockController.text,
          costPrice: _costController.text.isEmpty
              ? '0.00'
              : _costController.text,
          salePrice: _saleController.text.isEmpty
              ? '0.00'
              : _saleController.text,
        ),
      );

      _skuController.clear();
      _colorController.clear();
      _sizeController.clear();
      _stockController.clear();
      _costController.clear();
      _saleController.clear();
    });
  }

  @override
  void dispose() {
    _skuController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _stockController.dispose();
    _costController.dispose();
    _saleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTableShell(
      shrinkWrap: true,
      header: const AppTableHeader(columns: _columns),
      rows: [
        ..._variants.map(
          (variant) => AppTableRow(
            cells: [
              AppTableCell.text(variant.sku, flex: 2),
              AppTableCell.text(variant.color, flex: 2),
              AppTableCell.text(variant.size, flex: 2),
              AppTableCell.text(variant.stock, flex: 1),
              AppTableCell.text('\$${variant.costPrice}', flex: 2),
              AppTableCell.text('\$${variant.salePrice}', flex: 2),
            ],
          ),
        ),

        AppTableRow(
          showBottomBorder: false,
          cells: [
            AppTableCell.field(
              flex: 2,
              controller: _skuController,
              hint: "PR-001-BCO",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _colorController,
              hint: "Blanco",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _sizeController,
              hint: "40x40cm",
            ),
            AppTableCell.field(
              flex: 1,
              controller: _stockController,
              hint: "0",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _costController,
              hint: "0.00",
            ),
            AppTableCell.field(
              flex: 2,
              controller: _saleController,
              hint: "0.00",
            ),
          ],
          trailing: IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _addVariant,
          ),
        ),
      ],
    );
  }
}
