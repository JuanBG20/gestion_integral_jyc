import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_date_picker.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/quick_action_button.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/providers/work_provider.dart';
import 'package:gestion_integral_jyc/features/production/presentation/widgets/work_items_list_section.dart';
import 'package:go_router/go_router.dart';

class NewWorkScreen extends ConsumerStatefulWidget {
  final WorkEntity? workToEdit;

  const NewWorkScreen({super.key, this.workToEdit});

  @override
  ConsumerState<NewWorkScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewWorkScreen> {
  final _formKey = GlobalKey<FormState>();

  ClientEntity? _selectedClient;
  DateTime? _selectedDeadline;
  List<WorkItemEntity> _currentItems = [];

  double get _totalAmount =>
      _currentItems.fold(0, (sum, item) => sum + item.subtotal);

  bool get _isEditing => widget.workToEdit != null;

  @override
  void initState() {
    super.initState();

    final work = widget.workToEdit;
    if (work != null) {
      _selectedClient = work.client;
      _selectedDeadline = work.deadline;
      _currentItems = work.items;
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  void _saveWork() {
    if (_formKey.currentState!.validate()) {
      if (_selectedClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe seleccionar un cliente')),
        );
        return;
      }
      if (_currentItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debe agregar al menos un ítem')),
        );
        return;
      }

      final work = WorkEntity(
        id: widget.workToEdit?.id,
        creationDate: widget.workToEdit?.creationDate ?? DateTime.now(),
        deadline: _selectedDeadline,
        client: _selectedClient!,
        actualState:
            widget.workToEdit?.actualState ??
            WorkState.recibido, // Estado inicial por defecto
        items: _currentItems,
      );

      final notifier = ref.read(workProvider.notifier);
      final future = _isEditing
          ? notifier.updateWork(work)
          : notifier.addWork(work);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing
                      ? 'Órden de Trabajo actualizada'
                      : 'Órden de Trabajo guardada',
                ),
              ),
            );
            context.go('/work');
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientProvider);

    return FormScreenLayout(
      title: _isEditing
          ? "Editar Órden de Trabajo"
          : "Registrar Órden de Trabajo",
      subtitle: _isEditing
          ? "Modifique los detalles de la órden de trabajo seleccionada."
          : "Complete los detalles para registrar una nueva órden de trabajo.",
      returnLabel: "Volver al Kanban",
      saveLabel: _isEditing ? "Guardar Cambios" : "Guardar Órden",
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
                width: itemWidth,

                child: clientsState.when(
                  data: (clients) {
                    return LabeledDropdown(
                      label: "Cliente",
                      value: _selectedClient,
                      items: clients
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(
                                c.fullName,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      hint: "Seleccione un cliente",
                      onChanged: (val) => setState(() => _selectedClient = val),
                      validator: (value) => value == null ? 'Requerido' : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, s) => Text('Error al cargar clientes: $e'),
                ),
              ),

              SizedBox(
                width: itemWidth,
                child: LabeledDatePicker(
                  label: 'Fecha Límite (Opcional)',
                  hint: 'Seleccione una fecha...',
                  onTap: _pickDeadline,
                  value: _selectedDeadline,
                ),
              ),

              SizedBox(
                width: constraints.maxWidth,
                child: WorkItemsListSection(
                  initialItems: widget.workToEdit?.items ?? [],
                  onItemsChanged: (items) {
                    setState(() {
                      _currentItems = items;
                    });
                  },
                ),
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
                Text("Total de Ítems", style: context.textTheme.bodyMedium),
                Text(
                  "${_currentItems.length}",
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(color: AppColors.outline),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text("Total", style: context.textTheme.titleMedium),
                Text(
                  "\$${_totalAmount.toStringAsFixed(2)}",
                  style: context.textTheme.titleLarge,
                ),
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
      onSave: _saveWork,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
