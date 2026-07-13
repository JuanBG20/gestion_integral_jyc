import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class AppActionMenuItem {
  final String value;
  final String label;
  final IconData? icon;
  final bool isDestructive;

  const AppActionMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
  });
}

class AppActionMenu extends StatelessWidget {
  final List<AppActionMenuItem> items;
  final ValueChanged<String> onSelected;
  final IconData icon;

  const AppActionMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = Icons.more_horiz,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(icon, color: AppColors.onBackground),
      onSelected: onSelected,
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem(
              value: item.value,

              child: Text(
                item.label,
                style: item.isDestructive
                    ? TextStyle(color: AppColors.error)
                    : null,
              ),
            ),
          )
          .toList(),
    );
  }
}
