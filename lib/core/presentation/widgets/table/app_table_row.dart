import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_cell.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class AppTableRow extends StatelessWidget {
  final List<AppTableCell> cells;
  final Color? background;
  final EdgeInsetsGeometry padding;
  final Widget? trailing;
  final double trailingWidth;
  final bool showBottomBorder;

  const AppTableRow({
    super.key,
    required this.cells,
    this.background,
    this.padding = const EdgeInsets.only(
      top: 12,
      bottom: 12,
      left: 24,
      right: 24,
    ),
    this.trailing,
    this.trailingWidth = 40,
    this.showBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background ?? AppColors.background,
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: AppColors.outline))
            : null,
      ),

      child: Row(
        children: [
          ...cells.map((c) => Expanded(flex: c.flex, child: c.child)),
          SizedBox(
            width: trailingWidth,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
