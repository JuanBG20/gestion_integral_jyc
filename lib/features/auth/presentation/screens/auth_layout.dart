import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class AuthLayout extends StatelessWidget {
  final String title;
  final Widget form;
  final Widget bottomAction;
  final double maxWidth;

  const AuthLayout({
    super.key,
    required this.title,
    required this.form,
    required this.bottomAction,
    this.maxWidth = 420,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Icon(
                        Icons.precision_manufacturing,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(title, style: context.textTheme.titleLarge),

                    Text(
                      "Software de Gestión Empresarial",
                      style: context.textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 24),

                    form,
                  ],
                ),
              ),

              const SizedBox(height: 20),

              bottomAction,

              const SizedBox(height: 32),

              Text("v1.3.0", style: context.textTheme.bodySmall),
              Text(
                "© 2026 J&C Impresiones 3D. Todos los derechos reservados.",
                style: context.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
