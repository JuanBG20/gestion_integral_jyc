import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/breakdown_card.dart';

class PaymentMethodsCard extends StatelessWidget {
  final double? width;
  final List<BreakdownRowItemEntity> items;

  const PaymentMethodsCard({super.key, this.width, required this.items});

  @override
  Widget build(BuildContext context) {
    return BreakdownCard(
      width: width,
      title: "Ingresos por Método de Pago",
      col1Header: "Método",
      col2Header: "Ops.",
      col3Header: "Monto",
      items: items,
    );
  }
}
