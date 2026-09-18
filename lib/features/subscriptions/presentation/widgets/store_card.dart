import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StoreCard extends StatelessWidget {
  final String platform;
  final String store;
  final IconData icon;
  final String qrUrl;
  final Color color;

  const StoreCard({
    super.key,
    required this.platform,
    required this.store,
    required this.icon,
    required this.qrUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outline),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: color),
                ),

                child: Icon(icon, size: 32, color: color),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(platform, style: context.textTheme.bodyMedium),

                  Text(store, style: context.textTheme.bodySmall),
                ],
              ),
            ],
          ),

          QrImageView(
            data: qrUrl,
            version: QrVersions.auto,
            size: 200,

            backgroundColor: AppColors.surface,

            padding: const EdgeInsets.all(16.0),
          ),

          Row(
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 18,
                color: AppColors.onBackground.withValues(alpha: 0.8),
              ),

              const SizedBox(width: 8),

              Text(
                "Escaneá con tu celular",
                style: context.textTheme.bodySmall,
              ),
            ],
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.download),
            label: Text("Abrir $store"),
          ),
        ],
      ),
    );
  }
}
