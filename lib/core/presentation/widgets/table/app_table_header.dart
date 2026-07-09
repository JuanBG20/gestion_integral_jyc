import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/table/app_table_column.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class AppTableHeader extends StatelessWidget {
  final List<AppTableColumn> columns;
  final EdgeInsetsGeometry padding;
  final double trailingWidth;

  const AppTableHeader({
    super.key,
    required this.columns,
    this.padding = const EdgeInsets.all(24),
    this.trailingWidth = 40,
  });

  @override
  Widget build(BuildContext context) {
    final headerStyle = context.textTheme.bodyMedium?.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );

    return Container(
      padding: padding,
      decoration: const BoxDecoration(color: AppColors.surface),

      child: Row(
        children: [
          ...columns.map(
            (col) => Expanded(
              flex: col.flex,
              child: Text(col.label, style: headerStyle),
            ),
          ),
          SizedBox(width: trailingWidth),
        ],
      ),
    );
  }
}
