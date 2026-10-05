import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/features/reports/domain/entities/breakdown_row_item_entity.dart';
import 'package:gestion_integral_jyc/features/reports/presentation/widgets/breakdown_card.dart';

class AppliedDiscountsCard extends StatelessWidget {
  final double? width;
  final String totalAmount;
  final List<BreakdownRowItemEntity> items;

  const AppliedDiscountsCard({
    super.key,
    this.width,
    required this.totalAmount,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return BreakdownCard(
      width: width,
      title: "Descuentos Aplicados",
      badgeText: totalAmount,
      badgeColor: AppColors.error,
      col1Header: "Descripción",
      col2Header: "Usos",
      col3Header: "Monto",
      items: items,
    );
  }
}
