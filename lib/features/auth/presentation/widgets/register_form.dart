import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/auth_error_message.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/auth_submit_button.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lastnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final VoidCallback onObscureChange;
  final VoidCallback onSubmit;
  final AuthState authState;
  final GlobalKey<FormState> formKey;

  const RegisterForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onObscureChange,
    required this.onSubmit,
    required this.authState,
    required this.formKey,
    required this.nameController,
    required this.lastnameController,
    required this.confirmPasswordController,
  });

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty ? 'Requerido' : null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        children: [
          _buildResponsiveRow(
            context,
            LabeledTextField(
              controller: nameController,
              label: 'Nombre',
              hint: 'Juan Bautista',
              prefixIcon: const Icon(Icons.badge_outlined),
              validator: _required,
            ),
            LabeledTextField(
              controller: lastnameController,
              label: 'Apellido',
              hint: 'Galván',
              prefixIcon: const Icon(Icons.badge_outlined),
              validator: _required,
            ),
          ),

          const SizedBox(height: 20),

          LabeledTextField(
            controller: emailController,
            inputType: TextInputType.emailAddress,
            label: 'Email',
            hint: 'operario@gmail.com',
            prefixIcon: const Icon(Icons.person_outline),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Requerido';
              if (!value.contains('@')) return 'Email inválido';
              return null;
            },
          ),

          const SizedBox(height: 20),

          _buildResponsiveRow(
            context,
            LabeledTextField(
              controller: passwordController,
              obscureText: obscurePassword,
              label: 'Contraseña',
              hint: '*******',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onObscureChange,
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Requerido';
                if (value.length < 6) {
                  return 'Debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            LabeledTextField(
              controller: confirmPasswordController,
              obscureText: obscurePassword,
              label: 'Confirmar contraseña',
              hint: '*******',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: onObscureChange,
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Requerido';
                if (value != passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ),

          AuthErrorMessage(errorMessage: authState.errorMessage),

          const SizedBox(height: 20),

          AuthSubmitButton(
            isLoading: authState.isLoading,
            label: "Crear Cuenta",
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow(
    BuildContext context,
    Widget child1,
    Widget child2,
  ) {
    if (context.isMobileLayout) {
      return Column(children: [child1, const SizedBox(height: 20), child2]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(child: child1),
        const SizedBox(width: 16),
        Expanded(child: child2),
      ],
    );
  }
}
