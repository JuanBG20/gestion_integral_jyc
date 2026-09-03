import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;

  const AuthSubmitButton({
    super.key,
    required this.isLoading,
    this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        label: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
        icon: isLoading ? null : Icon(Icons.arrow_forward),
        iconAlignment: IconAlignment.end,
      ),
    );
  }
}
