import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/theme/app_colors.dart';
import 'package:gestion_integral_jyc/core/theme/theme_extensions.dart';

class FormScreenLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final String returnLabel;
  final String saveLabel;
  final GlobalKey<FormState> formKey;
  final Widget formContent;
  final Widget? sidePanel;
  final VoidCallback onReturn;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final double maxWidth;

  const FormScreenLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.returnLabel,
    required this.saveLabel,
    required this.formKey,
    required this.formContent,
    this.sidePanel,
    required this.onReturn,
    required this.onSave,
    required this.onCancel,
    this.maxWidth = 900,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: Align(
        alignment: Alignment.topCenter,

        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(title, style: context.textTheme.titleLarge),
                          Text(subtitle, style: context.textTheme.bodyLarge),
                        ],
                      ),
                    ),

                    if (!context.isMobileLayout) ...[
                      const SizedBox(width: 16),

                      TextButton.icon(
                        onPressed: onReturn,
                        label: Text(returnLabel),
                        icon: Icon(Icons.arrow_back),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 32),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final Widget mainFormCard = Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.outline),
                        borderRadius: BorderRadius.circular(4),
                      ),

                      child: Form(
                        key: formKey,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            formContent,

                            const SizedBox(height: 24),

                            Divider(color: AppColors.outline),

                            const SizedBox(height: 16),

                            if (constraints.isDesktopLayout) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,

                                children: [
                                  OutlinedButton(
                                    onPressed: onCancel,
                                    child: Text("Cancelar"),
                                  ),

                                  const SizedBox(width: 16),

                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        onSave();
                                      }
                                    },
                                    label: Text(saveLabel),
                                    icon: Icon(Icons.save_outlined),
                                  ),
                                ],
                              ),
                            ] else
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,

                                    child: OutlinedButton(
                                      onPressed: onCancel,
                                      child: Text("Cancelar"),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  SizedBox(
                                    width: double.infinity,

                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          onSave();
                                        }
                                      },
                                      label: Text(saveLabel),
                                      icon: Icon(Icons.save_outlined),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );

                    if (sidePanel == null) return mainFormCard;

                    if (constraints.isDesktopLayout) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(flex: 6, child: mainFormCard),

                          const SizedBox(width: 24),

                          Expanded(flex: 4, child: sidePanel!),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          mainFormCard,
                          const SizedBox(height: 24),
                          sidePanel!,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
