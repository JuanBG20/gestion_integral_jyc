import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class AppTableShell extends StatelessWidget {
  final Widget header;
  final List<Widget> rows;
  final double minWidth;
  final bool shrinkWrap;

  const AppTableShell({
    super.key,
    required this.header,
    required this.rows,
    this.minWidth = 1000,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth = constraints.maxWidth > minWidth
            ? constraints.maxWidth
            : minWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: SizedBox(
            width: tableWidth,

            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(4),
              ),

              child: ListView(
                shrinkWrap: shrinkWrap,
                physics: shrinkWrap
                    ? const NeverScrollableScrollPhysics()
                    : null,
                children: [header, ...rows],
              ),
            ),
          ),
        );
      },
    );
  }
}
