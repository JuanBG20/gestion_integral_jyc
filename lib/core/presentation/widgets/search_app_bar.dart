import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outline)),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                height: 32,
                width: 256,

                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    hintText: "Buscar...",
                    prefixIcon: Icon(Icons.search, color: AppColors.outline),
                  ),
                ),
              ),

              Spacer(),

              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined),
              ),

              const SizedBox(width: 8),

              VerticalDivider(
                indent: 8,
                endIndent: 8,
                color: AppColors.outline,
              ),

              const SizedBox(width: 16),

              InkWell(
                onTap: () {},

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text("Administrador"),
                    Text(
                      "Juan Bautista Galván",
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
