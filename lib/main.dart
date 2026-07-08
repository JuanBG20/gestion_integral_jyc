import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_theme.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/new_work_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Layout(child: NewWorkScreen())),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
