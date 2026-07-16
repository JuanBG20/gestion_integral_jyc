import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/all_works_screen.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_screen.dart';

class WorkAdaptativeScreen extends StatelessWidget {
  const WorkAdaptativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.isMobileLayout) {
          return const AllWorksScreen();
        }

        return const WorkScreen();
      },
    );
  }
}
