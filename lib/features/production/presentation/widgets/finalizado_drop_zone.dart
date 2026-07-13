import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';

class FinalizadoDropZone extends ConsumerWidget {
  const FinalizadoDropZone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<WorkEntity>(
      onWillAcceptWithDetails: (details) =>
          details.data.actualState != WorkState.finalizado,
      onAcceptWithDetails: (details) {
        if (details.data.id != null) {
          ref
              .read(workProvider.notifier)
              .updateWorkStatus(details.data.id!, WorkState.finalizado);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trabajo TRB-${details.data.id} marcado como FINALIZADO y enviado a Ventas.',
              ),
            ),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isHovered ? 100 : 80,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isHovered ? Colors.green.shade50 : Colors.grey.shade50,
            border: Border.all(
              color: isHovered ? Colors.green : Colors.grey.shade400,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4),
          ),

          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: isHovered ? Colors.green : Colors.grey.shade600,
                  size: 32,
                ),

                const SizedBox(width: 12),

                Text(
                  isHovered
                      ? '¡Soltar para finalizar!'
                      : 'Arrastrar aquí los trabajos abonados y retirados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isHovered ? Colors.green : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
