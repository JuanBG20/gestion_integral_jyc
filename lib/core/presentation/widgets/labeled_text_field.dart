import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class LabeledTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? inputType;
  final String label;
  final String hint;
  final Icon? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;

  const LabeledTextField({
    super.key,
    required this.controller,
    this.inputType = TextInputType.text,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        TextFormField(
          readOnly: readOnly,
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
