import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final VoidCallback onObscureChange;
  final Function(bool?) onRememberChange;
  final VoidCallback onSubmit;
  final AuthState authState;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onObscureChange,
    required this.onRememberChange,
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

          if (authState.errorMessage != null) ...[
            const SizedBox(height: 12),

            Text(
              authState.errorMessage!,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
            ),
          ],

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: CheckboxListTile(
                  value: rememberMe,
                  onChanged: onRememberChange,
                  title: Text("Recordarme"),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              TextButton(
                onPressed: () {},
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: authState.isLoading ? null : onSubmit,
              label: authState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text("Iniciar Sesión"),
              icon: authState.isLoading ? null : Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
            ),
          ),
        ],
      ),
    );
  }
}
