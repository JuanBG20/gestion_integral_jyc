import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final bool hasSecondaryButton;
  final String? secondaryButtonLabel;
  final IconData? secondaryButtonIcon;
  final VoidCallback? onPressedSecundary;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    this.hasSecondaryButton = false,
    this.onPressedSecundary,
    this.secondaryButtonLabel,
    this.secondaryButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.isMobileLayout) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: context.textTheme.titleLarge),
              Text(subtitle, style: context.textTheme.bodyLarge),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(title, style: context.textTheme.titleLarge),
                  Text(subtitle, style: context.textTheme.bodyLarge),
                ],
              ),
            ),

            const SizedBox(width: 16),

            Row(
              children: [
                if (hasSecondaryButton) ...[
                  OutlinedButton.icon(
                    onPressed: onPressedSecundary,
                    label: Text(secondaryButtonLabel ?? ''),
                    icon: Icon(secondaryButtonIcon),
                  ),

                  const SizedBox(width: 16),
                ],

                ElevatedButton.icon(
                  onPressed: onPressed,
                  label: Text(buttonLabel),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
