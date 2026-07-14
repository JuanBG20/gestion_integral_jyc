import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/client_formatting.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class SaleClientInfoCard extends StatelessWidget {
  final ClientEntity client;

  const SaleClientInfoCard({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(4),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("Información del Cliente", style: context.textTheme.titleMedium),

          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final bool isTwoColumns = constraints.maxWidth > 450;
              final double fieldWidth = isTwoColumns
                  ? (constraints.maxWidth - 24) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _buildInfoField(
                      context,
                      label: "Nombre",
                      value: client.fullName,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _buildInfoField(
                      context,
                      label: "Documento",
                      value: client.formattedDocument,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _buildInfoField(
                      context,
                      label: "Email",
                      value: client.displayEmail,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _buildInfoField(
                      context,
                      label: "Teléfono",
                      value: client.displayPhone,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
