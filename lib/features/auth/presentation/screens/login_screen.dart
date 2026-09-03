import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/auth_provider.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/screens/auth_layout.dart';
import 'package:gestion_integral_jyc/features/auth/presentation/widgets/hover_link.dart';
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

    return AuthLayout(
      title: "J&C Impresiones 3D",
      form: LoginForm(
        emailController: _emailController,
        passwordController: _passwordController,
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
          Text("¿No tenés cuenta? ", style: context.textTheme.bodyMedium),

          HoverLink(text: "Registrate", onTap: () => context.go('/register')),
        ],
      ),
    );
  }
}
