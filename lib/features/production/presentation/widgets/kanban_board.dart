import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:intl/intl.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard({super.key});

  @override
  State<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  late List<WorkEntity> _mockWorks;

  void initState() {
    super.initState();
    final client1 = ClientEntity(id: 1, name: 'Martín', lastName: 'Rodríguez');
    final client2 = ClientEntity(id: 2, name: 'Laura', lastName: 'Gómez');

    _mockWorks = [
      WorkEntity(
        id: 1042,
        client: client1,
        actualState: WorkState.recibido,
        creationDate: DateTime.now(),
        deadline: DateTime.now().add(const Duration(days: 1)),
        items: [
          WorkItemEntity(
            quantity: 3,
            unitPrice: 500,
            description: 'Llavero Genérico 3D',
          ),
          WorkItemEntity(
            quantity: 1,
            unitPrice: 2000,
            description: 'Cuadro MDF 3mm (Corte)',
          ),
        ],
      ),
      WorkEntity(
        id: 1041,
        client: client2,
        actualState: WorkState.disenado,
        creationDate: DateTime.now(),
        deadline: DateTime.now().add(const Duration(days: 3)),
        items: [
          WorkItemEntity(
            quantity: 5,
            unitPrice: 800,
            description: 'Impresión Molde PLA',
            isDone: true,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildColumn('RECIBIDO', WorkState.recibido),
              _buildColumn('DISEÑADO', WorkState.disenado),
              _buildColumn('HECHO', WorkState.hecho),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildFinalizadoDropZone(),
      ],
    );
  }

  Widget _buildColumn(String title, WorkState columnState) {
    final columnWorks = _mockWorks
        .where((w) => w.actualState == columnState)
        .toList();

    return Expanded(
      child: DragTarget<WorkEntity>(
        onWillAcceptWithDetails: (details) => true,
        onAcceptWithDetails: (details) {
          setState(() {
            final index = _mockWorks.indexWhere((w) => w.id == details.data.id);
            if (index != -1) {
              // TODO: Llamada a provider
              _mockWorks[index] = WorkEntity(
                id: _mockWorks[index].id,
                client: _mockWorks[index].client,
                creationDate: _mockWorks[index].creationDate,
                deadline: _mockWorks[index].deadline,
                items: _mockWorks[index].items,
                actualState: columnState,
              );
            }
          });
        },
        builder: (context, candidateData, rejectedData) {
          final isHovered = candidateData.isNotEmpty;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isHovered
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isHovered ? AppColors.primary : AppColors.outline,
              ),
              borderRadius: BorderRadius.circular(4),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(title),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),

                        child: Text('${columnWorks.length}'),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: columnWorks.length,
                    itemBuilder: (context, index) {
                      return _buildDraggableCard(columnWorks[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableCard(WorkEntity work) {
    final cardUI = Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: AppColors.outline),
      ),

      child: Padding(
        padding: const EdgeInsets.all(12.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'TRB-${work.id}',
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              work.client.fullName,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.onBackground,
              ),
            ),

            const SizedBox(height: 4),

            if (work.deadline != null)
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 12,
                    color: AppColors.onBackground,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    DateFormat('MMM. d').format(work.deadline!),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),

            const SizedBox(height: 8),

            if (work.items.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: work.items
                    .map((item) => _buildItemRow(item))
                    .toList(),
              ),

            Divider(color: AppColors.outline),

            OutlinedButton(onPressed: () {}, child: Text("Emitir Presupuesto")),
          ],
        ),
      ),
    );

    return Draggable<WorkEntity>(
      data: work,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(width: 260, child: cardUI),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: cardUI),
      child: InkWell(onTap: () {}, child: cardUI),
    );
  }

  Widget _buildItemRow(WorkItemEntity item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(
            item.isDone
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank,
            size: 14,
            color: item.isDone ? Colors.green : AppColors.onBackground,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Text(
              '${item.quantity}x ${item.description ?? 'Sin desc.'}',
              style: context.textTheme.bodySmall?.copyWith(
                color: item.isDone
                    ? AppColors.onBackground.withValues(alpha: 0.8)
                    : AppColors.onBackground,
                decoration: item.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: AppColors.onBackground,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // --- DROP ZONE ---
  Widget _buildFinalizadoDropZone() {
    return DragTarget<WorkEntity>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        setState(() {
          // TODO: Provider

          _mockWorks.removeWhere((w) => w.id == details.data.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Trabajo TRB-${details.data.id} cobrado y finalizado.',
              ),
            ),
          );
        });
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
