import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/labeled_text_field.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabeledTextField(
                            controller: _emailController,
                            inputType: TextInputType.emailAddress,
                            label: 'Email',
                            hint: 'operario@gmail.com',
                            prefixIcon: const Icon(Icons.person_outline),
                          ),

                          const SizedBox(height: 20),

                          LabeledTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            label: 'Contraseña',
                            hint: '*******',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  value: _rememberMe,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _rememberMe = newValue ?? false;
                                    });
                                  },
                                  title: Text("Recordarme"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
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
                              onPressed: () {},
                              label: Text("Iniciar Sesión"),
                              icon: Icon(Icons.arrow_forward),
                              iconAlignment: IconAlignment.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text("v1.0.0", style: context.textTheme.bodySmall),
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
