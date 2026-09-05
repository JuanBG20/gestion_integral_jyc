import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class AppCardShell extends StatelessWidget {
  final List<Widget> cardContent;
  final VoidCallback? onTapCard;

  const AppCardShell({super.key, required this.cardContent, this.onTapCard});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outline),
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTapCard,

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: cardContent,
          ),
        ),
      ),
    );
  }
}
