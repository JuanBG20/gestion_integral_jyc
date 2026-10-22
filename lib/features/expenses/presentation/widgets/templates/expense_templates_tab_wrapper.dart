import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/features/expenses/domain/entities/expense_template_entity.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/providers/expense_provider.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/templates/expense_template_card.dart';
import 'package:gestion_integral_jyc/features/expenses/presentation/widgets/templates/expense_templates_tab.dart';

class ExpenseTemplatesTabWrapper extends ConsumerWidget {
  final bool isAdmin;

  const ExpenseTemplatesTabWrapper({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final templatesState = ref.watch(expenseTemplateProvider);

    return templatesState.when(
      data: (templates) {
        if (templates.isEmpty) {
          return const Center(child: Text("No hay suscripciones registradas."));
        }

        final filteredTemplates = templates.where((template) {
          final descMatch = template.description.toLowerCase().contains(
            searchQuery,
          );
          final catMatch = template.category.name.toLowerCase().contains(
            searchQuery,
          );
          return descMatch || catMatch;
        }).toList();

        if (filteredTemplates.isEmpty) {
          return const Center(
            child: Text("No se encontraron suscripciones con esa búsqueda."),
          );
        }

        return context.isMobileLayout
            ? AppMobileList<ExpenseTemplateEntity>(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                items: filteredTemplates,
                itemBuilder: (context, template) =>
                    ExpenseTemplateCard(template: template, isAdmin: isAdmin),
              )
            : Padding(
                padding: const EdgeInsets.all(24),
                child: ExpenseTemplatesTab(
                  isAdmin: isAdmin,
                  templates: templates,
                ),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) =>
          Center(child: Text("Error al cargar plantillas: $e")),
    );
  }
}
