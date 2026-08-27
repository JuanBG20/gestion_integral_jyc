import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/login_form.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signIn(_emailController.text.trim(), _passwordController.text);

      final authState = ref.read(authProvider);
      if (authState.isAuthenticated && mounted) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 420),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Icon(
                        Icons.precision_manufacturing,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      "J&C Impresiones 3D",
                      style: context.textTheme.titleLarge,
                    ),
                    Text(
                      "Software de Gestión Empresarial",
                      style: context.textTheme.bodyLarge,
                    ),

                    const SizedBox(height: 24),

                    // TODO: Lógica de RememberMe y Olvidaste tu Contraseña
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      rememberMe: _rememberMe,
                      onObscureChange: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      onRememberChange: (bool? newValue) {
                        /* setState(() {
                          _rememberMe = newValue ?? false;
                        }); */
                      },
                      onSubmit: _submit,
                      authState: authState,
                      formKey: _formKey,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text("v1.2.0", style: context.textTheme.bodySmall),
              Text(
                "© 2026 J&C Impresiones 3D. Todos los derechos reservados.",
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
