import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';

class ResponsiveFilterBar extends StatelessWidget {
  final List<Widget> filters;

  const ResponsiveFilterBar({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.isMobileLayout) {
          return Column(
            children: [
              for (int i = 0; i < filters.length; i++) ...[
                SizedBox(width: double.infinity, child: filters[i]),

                if (i < filters.length - 1) SizedBox(height: 16),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < filters.length; i++) ...[
              Expanded(child: filters[i]),

              if (i < filters.length - 1) SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}
