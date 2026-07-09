import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewClientScreen extends ConsumerStatefulWidget {
  const NewClientScreen({super.key});

  @override
  ConsumerState<NewClientScreen> createState() => _NewRawMaterialScreenState();
}

class _NewRawMaterialScreenState extends ConsumerState<NewClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _locationController = TextEditingController();
  final _provinceController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _notesController = TextEditingController();

  DocType _selectedDocType = DocType.dni;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _docNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _locationController.dispose();
    _provinceController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final newClient = ClientEntity(
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        docType: _selectedDocType,
        docNumber: _docNumberController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        additionalNotes: _notesController.text.trim(),
        address: AddressEntity(
          street: _streetController.text.trim(),
          number: _numberController.text.trim(),
          location: _locationController.text.trim(),
          province: _provinceController.text.trim(),
          floor: _floorController.text.trim(),
          apartment: _apartmentController.text.trim(),
        ),
      );

      ref
          .read(clientProvider.notifier)
          .addClient(newClient)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente guardado exitosamente')),
            );
            context.go('/clients');
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
    return FormScreenLayout(
      title: "Registrar Cliente",
      subtitle:
          "Ingrese los detalles para crear un nuevo cliente. Los campos obligatorios están marcados con un asterisco (*).",
      returnLabel: "Volver a Clientes",
      saveLabel: "Guardar Cliente",
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

                child: LabeledTextField(
                  controller: _nameController,
                  label: "Nombre (*)",
                  hint: "Juan Bautista",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _lastNameController,
                  label: "Apellido (*)",
                  hint: "Galván",
                ),
              ),

              /* SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: TextEditingController(),
                  label: "Tido de Documento",
                  hint: "DNI",
                ),
              ), */
              SizedBox(
                width: itemWidth,

                child: LabeledDropdown(
                  label: "Tipo de Documento",
                  value: _selectedDocType,
                  hint: "Selecciona un tipo...",
                  items: DocType.values.map((type) {
                    return DropdownMenuItem<DocType>(
                      value: type,
                      child: Text(
                        type.dbValue,
                        style: context.textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      if (val != null) _selectedDocType = val;
                    });
                  },
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _docNumberController,
                  label: "Número de Documento",
                  hint: "46427900",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Contacto", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _phoneController,
                  label: "Teléfono",
                  hint: "2364509648",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _emailController,
                  label: "Email",
                  hint: "juanbgalvan.19@gmail.com",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: Text("Dirección", style: context.textTheme.titleMedium),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _streetController,
                  label: "Calle",
                  hint: "Tucumán",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _numberController,
                  label: "Número",
                  hint: "199",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _locationController,
                  label: "Localidad",
                  hint: "Arribeños",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _provinceController,
                  label: "Provincia",
                  hint: "Buenos Aires",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _floorController,
                  label: "Piso",
                  hint: "5",
                ),
              ),

              SizedBox(
                width: itemWidth,

                child: LabeledTextField(
                  controller: _apartmentController,
                  label: "Departamento",
                  hint: "A",
                ),
              ),

              Divider(color: AppColors.outline),

              SizedBox(
                width: constraints.maxWidth,

                child: LabeledTextField(
                  controller: _notesController,
                  label: "Notas Adicionales",
                  hint: "Cualquier detalle del cliente...",
                ),
              ),
            ],
          );
        },
      ),

      onReturn: () {
        context.go('/clients');
      },
      onSave: _saveClient,
      onCancel: () {
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }
}
