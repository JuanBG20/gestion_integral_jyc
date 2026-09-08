import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_integral_jyc/core/presentation/extensions/screen_size.dart';
import 'package:gestion_integral_jyc/core/presentation/providers/search_provider.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/app_mobile_list.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/raw_material_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/providers/raw_material_provider.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/raw_materials/raw_material_card.dart';
import 'package:gestion_integral_jyc/features/inventory/presentation/widgets/raw_materials/raw_materials_tab.dart';

class RawMaterialsTabWrapper extends ConsumerWidget {
  final bool isAdmin;

  const RawMaterialsTabWrapper({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final rawMaterialsState = ref.watch(rawMaterialProvider);

    return rawMaterialsState.when(
      data: (rawMaterials) {
        if (rawMaterials.isEmpty) {
          return const Center(child: Text("No hay materia primar registrada."));
        }

        final filteredRawMaterials = rawMaterials.where((rm) {
          final descriptionMatch = rm.description.toLowerCase().contains(
            searchQuery,
          );
          final categoryMatch = rm.category.toLowerCase().contains(searchQuery);
          final subcategoryMatch = rm.subcategory.toLowerCase().contains(
            searchQuery,
          );
          final skuMatch = rm.sku.toLowerCase().contains(searchQuery);

          return descriptionMatch ||
              categoryMatch ||
              subcategoryMatch ||
              skuMatch;
        }).toList();

        if (filteredRawMaterials.isEmpty) {
          return const Center(
            child: Text("No se encontraron materias primas."),
          );
        }

        return context.isMobileLayout
            ? AppMobileList<RawMaterialEntity>(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                items: filteredRawMaterials,
                itemBuilder: (context, rawMaterial) =>
                    RawMaterialCard(rawMaterial: rawMaterial, isAdmin: isAdmin),
              )
            : Padding(
                padding: const EdgeInsets.all(24),

                child: RawMaterialsTab(
                  rawMaterials: filteredRawMaterials,
                  isAdmin: isAdmin,
                ),
              );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => Center(child: Text("Error: $e")),
    );
  }
}
