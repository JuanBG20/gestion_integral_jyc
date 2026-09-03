import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';

class HoverLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const HoverLink({super.key, required this.text, required this.onTap});

  @override
  State<HoverLink> createState() => _HoverLinkState();
}

class _HoverLinkState extends State<HoverLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),

      child: GestureDetector(
        onTap: widget.onTap,

        child: Text(
          widget.text,
          style: TextStyle().copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            decoration: _isHovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
