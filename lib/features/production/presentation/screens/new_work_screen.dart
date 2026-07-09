import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/work_items_list_section.dart';
import 'package:go_router/go_router.dart';

class NewWorkScreen extends StatefulWidget {
  const NewWorkScreen({super.key});

  @override
  State<NewWorkScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends State<NewWorkScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormScreenLayout(
      title: "Registrar Órden de Trabajo",
      subtitle:
          "Complete los detalles para registrar una nueva órden de trabajo.",
      returnLabel: "Volver al Kanban",
      saveLabel: "Guardar Órden",
      maxWidth: 1200,
      formKey: _formKey,
      formContent: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 500;
          final double itemWidth = isWide
              ? (constraints.maxWidth - 24) / 2
              : constraints.maxWidth;

          return Wrap(
            spacing: 24,
            runSpacing: 24,

            children: [
              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Cliente",
                  hint: "Juan Bautista Galván",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Fecha Límite (Opcional)",
                  hint: "mm/dd/yyyy",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Estado Inicial",
                  hint: "Recibido",
                ),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: const WorkItemsListSection(),
              ),
            ],
          );
        },
      ),
      sidePanel: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.outline),
          borderRadius: BorderRadius.circular(4),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("Resumen", style: context.textTheme.titleMedium),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Productos", style: context.textTheme.bodyMedium),
                Text("\$500", style: context.textTheme.bodyMedium),
              ],
            ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Total", style: context.textTheme.titleMedium),
                Text("\$500", style: context.textTheme.titleLarge),
              ],
            ),

            const SizedBox(height: 16),

            QuickActionButton(
              label: "Emitir Presupuesto",
              icon: Icons.print_outlined,
            ),
          ],
        ),
      ),
      onReturn: () {
        context.go('/work');
      },
      onSave: () {},
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
