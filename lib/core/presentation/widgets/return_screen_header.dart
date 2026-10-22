import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:go_router/go_router.dart';

class ReturnScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String returnLabel;
  final String returnUri;
  final String? additionalSubtitle;

  const ReturnScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.returnLabel,
    required this.returnUri,
    this.additionalSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(title, style: context.textTheme.titleLarge),
              Text(subtitle, style: context.textTheme.bodyLarge),
              if (additionalSubtitle != null && additionalSubtitle!.isNotEmpty)
                Text(additionalSubtitle!, style: context.textTheme.bodyLarge),
            ],
          ),
        ),

        if (!context.isMobileLayout) ...[
          const SizedBox(width: 16),

          TextButton.icon(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(returnUri);
              }
            },
            label: Text(returnLabel),
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ],
    );
  }
}
