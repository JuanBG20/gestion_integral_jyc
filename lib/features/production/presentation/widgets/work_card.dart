import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/date_formatting.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/deadline_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_action_menu.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/utils/work_actions_extension.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/status_badge.dart';
import 'package:go_router/go_router.dart';

class WorkCard extends StatelessWidget {
  final WorkEntity work;

  const WorkCard({super.key, required this.work});

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
        onTap: () => context.go('/work/detail', extra: work),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'TRB-${work.id ?? ''}',
                          style: context.textTheme.titleMedium,
                        ),

                        Text(
                          work.client.fullName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  AppActionMenu(
                    items: [
                      const AppActionMenuItem(
                        value: 'details',
                        label: 'Ver Detalle',
                      ),
                      const AppActionMenuItem(value: 'edit', label: 'Editar'),
                    ],
                    onSelected: (value) =>
                        context.handleWorkAction(work, value),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              StatusBadge(status: work.actualState.dbValue),

              const SizedBox(height: 4),

              Divider(color: AppColors.outline),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("CREACIÓN"),
                      Text(work.creationDate.ddMMyyyy),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Text("FECHA LÍMITE"),
                      Text(
                        work.deadline != null ? work.deadline!.ddMMyyyy : '-',
                        style: work.deadline != null
                            ? TextStyle(color: work.deadline!.deadlineColor)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
