import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/screens/auth_layout.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/hover_link.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/register_form.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
            _lastnameController.text.trim(),
          );

      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return AuthLayout(
      title: "Crear Cuenta",
      maxWidth: 600,
      form: authState.needsEmailConfirmation
          ? _buildEmailConfirmationMessage()
          : RegisterForm(
              nameController: _nameController,
              lastnameController: _lastnameController,
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              obscurePassword: _obscurePassword,
              onObscureChange: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              onSubmit: _submit,
              authState: authState,
              formKey: _formKey,
            ),
      bottomAction: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("¿Ya tenés cuenta? ", style: context.textTheme.bodyMedium),

          HoverLink(text: "Iniciá Sesión", onTap: () => context.go('/login')),
        ],
      ),
    );
  }

  Widget _buildEmailConfirmationMessage() {
    return Column(
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 48,
          color: AppColors.primary,
        ),

        const SizedBox(height: 16),

        Text(
          "Te enviamos un correo de confirmación. "
          "Abrilo para activar tu cuenta y después iniciá sesión.",
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium,
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.go('/login'),
            child: Text("Ir a iniciar sesión"),
          ),
        ),
      ],
    );
  }
}
