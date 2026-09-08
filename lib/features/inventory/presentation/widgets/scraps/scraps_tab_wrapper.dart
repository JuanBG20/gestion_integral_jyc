import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/scrap_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/scrap_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/scraps/scrap_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/scraps/scraps_tab.dart';

class ScrapsTabWrapper extends ConsumerWidget {
  final bool isAdmin;

  const ScrapsTabWrapper({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final scrapsState = ref.watch(scrapProvider);

    return scrapsState.when(
      data: (scraps) {
        if (scraps.isEmpty) {
          return const Center(child: Text("No hay retazos registrados."));
        }

        final filteredScraps = scraps.where((scrap) {
          final descriptionMatch = scrap.rawMaterial.description
              .toLowerCase()
              .contains(searchQuery);
          final skuMatch = scrap.rawMaterial.sku.toLowerCase().contains(
            searchQuery,
          );

          return descriptionMatch || skuMatch;
        }).toList();

        if (filteredScraps.isEmpty) {
          return const Center(
            child: Text("No se encontraron materias primas."),
          );
        }

        return context.isMobileLayout
            ? AppMobileList<ScrapEntity>(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                items: filteredScraps,
                itemBuilder: (context, scrap) =>
                    ScrapCard(scrap: scrap, isAdmin: isAdmin),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: ScrapsTab(isAdmin: isAdmin, scraps: filteredScraps),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error al cargar retazos: $e")),
    );
  }
}
