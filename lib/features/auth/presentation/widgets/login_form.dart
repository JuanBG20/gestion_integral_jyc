import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/auth_error_message.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/auth_submit_button.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onObscureChange;
  final VoidCallback onSubmit;
  final AuthState authState;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onObscureChange,
    required this.onSubmit,
    required this.authState,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        children: [
          LabeledTextField(
            controller: emailController,
            inputType: TextInputType.emailAddress,
            label: 'Email',
            hint: 'operario@gmail.com',
            prefixIcon: const Icon(Icons.person_outline),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'Requerido' : null,
          ),

          const SizedBox(height: 20),

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
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Requerido' : null,
          ),

          AuthErrorMessage(errorMessage: authState.errorMessage),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () {},
            child: Text(
              "¿Olvidaste tu contraseña?",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          AuthSubmitButton(
            isLoading: authState.isLoading,
            label: "Iniciar Sesión",
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}
