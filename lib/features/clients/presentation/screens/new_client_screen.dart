import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/domain/entities/address_entity.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/doc_type.dart';
import 'package:gestion_integral_jyc/core/enums/provincia.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_dropdown.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/clients/presentation/providers/client_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/screens/form_screen_layout.dart';
import 'package:go_router/go_router.dart';

class NewClientScreen extends ConsumerStatefulWidget {
  final ClientEntity? clientToEdit;

  const NewClientScreen({super.key, this.clientToEdit});

  @override
  ConsumerState<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends ConsumerState<NewClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _docNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _locationController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _notesController = TextEditingController();

  DocType? _selectedDocType;
  Provincia? _selectedProvince;

  bool get _isEditing => widget.clientToEdit != null;

  @override
  void initState() {
    super.initState();

    final client = widget.clientToEdit;
    if (client != null) {
      _nameController.text = client.name;
      _lastNameController.text = client.lastName;
      _docNumberController.text = client.docNumber ?? '';
      _phoneController.text = client.phoneNumber ?? '';
      _emailController.text = client.email ?? '';
      _streetController.text = client.address?.street ?? '';
      _numberController.text = client.address?.number ?? '';
      _locationController.text = client.address?.location ?? '';
      _floorController.text = client.address?.floor ?? '';
      _apartmentController.text = client.address?.apartment ?? '';
      _notesController.text = client.additionalNotes ?? '';
      _selectedDocType = client.docType;
      _selectedProvince = client.address?.province;
    }
  }

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
    _floorController.dispose();
    _apartmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _nullableText(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final address = AddressEntity(
        street: _nullableText(_streetController),
        number: _nullableText(_numberController),
        location: _nullableText(_locationController),
        province: _selectedProvince,
        floor: _nullableText(_floorController),
        apartment: _nullableText(_apartmentController),
      );

      final client = ClientEntity(
        id: widget.clientToEdit?.id,
        name: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        docType: _selectedDocType,
        docNumber: _nullableText(_docNumberController),
        phoneNumber: _nullableText(_phoneController),
        email: _nullableText(_emailController),
        additionalNotes: _nullableText(_notesController),
        address: address.isEmpty ? null : address,
      );

      final notifier = ref.read(clientProvider.notifier);
      final future = _isEditing
          ? notifier.updateClient(client)
          : notifier.addClient(client);

      future
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isEditing ? 'Cliente actualizado' : 'Cliente guardado',
                ),
              ),
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
      title: _isEditing ? "Editar Cliente" : "Registrar Cliente",
      subtitle: _isEditing
          ? "Modifique los detalles del cliente seleccionado."
          : "Ingrese los detalles para crear un nuevo cliente. Los campos obligatorios están marcados con un asterisco (*).",
      returnLabel: "Volver a Clientes",
      saveLabel: _isEditing ? "Guardar Cambios" : "Guardar Cliente",
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
                  onChanged: (val) => setState(() => _selectedDocType = val),
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

                child: LabeledDropdown(
                  label: "Provincia",
                  value: _selectedProvince,
                  hint: "Selecciona una provincia...",
                  items: Provincia.values
                      .map(
                        (p) => DropdownMenuItem(value: p, child: Text(p.label)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() => _selectedProvince = val),
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
