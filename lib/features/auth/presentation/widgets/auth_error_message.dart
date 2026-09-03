import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class AuthErrorMessage extends StatelessWidget {
  final String? errorMessage;

  const AuthErrorMessage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),

      child: Text(
        errorMessage!,
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),
    );
  }
}
