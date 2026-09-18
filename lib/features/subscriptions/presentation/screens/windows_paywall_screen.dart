import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/subscriptions/presentation/widgets/store_card.dart';

class WindowsPaywallScreen extends StatelessWidget {
  const WindowsPaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.outline),
              ),

              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Subscribite a Gestión J&C Premium desde tu Dispositivo Móvil",
                        style: context.textTheme.titleLarge,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Para garantizar compras seguras con respaldo de Google Play y App Store, la subscripción al plan Premium se realiza exclusivamente a través de nuestras aplicaciones oficiales en Android o iOS.",
                        style: context.textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 8),

                      // Lista de beneficios
                    ],
                  ),

                  Container(
                    child: Column(
                      children: [
                        Container(child: Icon(Icons.cached_rounded)),

                        const SizedBox(height: 8),

                        Text("¡Una sola subscripción!"),

                        const SizedBox(height: 8),

                        Text(
                          "Una vez completada la subscripción en tu teléfono, esta aplicación se desbloquará de forma automática.",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.outline),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(Icons.download_rounded, color: AppColors.primary),

                      const SizedBox(width: 8),

                      Text(
                        "Descargá Gestión J&C en tu teléfono para comenzar",
                        style: context.textTheme.titleMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Escaneá el código QR con la cámara de tu celular o buscala directamente en la tienda oficial.",
                    style: context.textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      StoreCard(
                        platform: 'Android',
                        store: 'Play Store',
                        icon: Icons.play_arrow_rounded,
                        qrUrl: 'https://mimir.dedalostudio.com.ar',
                        color: Colors.green,
                      ),

                      StoreCard(
                        platform: 'iOS',
                        store: 'App Store',
                        icon: Icons.apple,
                        qrUrl: 'https://mimir.dedalostudio.com.ar',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
