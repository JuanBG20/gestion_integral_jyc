import 'package:gestion_integral_jyc/features/inventory/data/models/base_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/variant_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProductRemoteDataSource(this.supabaseClient);

  Future<List<Map<String, dynamic>>> fetchInventoryWithVariants() async {
    final response = await supabaseClient.from('producto_base').select('''
      *,
      producto_variante (
        *,
        fabrica (
          *,
          materia_prima (*)
        )
      )
    ''');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createFullProductRPC(
    BaseProductModel base,
    List<VariantProductModel> variants,
  ) async {
    final payload = {
      'p_sku_base': base.baseSku.trim().isEmpty ? null : base.baseSku.trim(),
      'p_categoria': base.category,
      'p_subcategoria': base.subcategory,
      'p_descripcion': base.description,
      'p_variantes': variants
          .map(
            (v) => {
              'sku': v.sku.trim().isEmpty ? null : v.sku.trim(),
              'stock': v.stock,
              'costPrice': v.costPrice,
              'salePrice': v.salePrice,
              'color': v.color,
              'size': v.size,
              'measurementUnit': v.measurementUnit.dbValue,
              'recipe': v.manufacturingRecipe
                  .map(
                    (r) => {
                      'rawMaterialId': r.rawMaterial.id,
                      'quantity': r.quantity,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
    };

    await supabaseClient.rpc('crear_producto_completo', params: payload);
  }

  Future<void> updateFullProduct(
    BaseProductModel base,
    List<VariantProductModel> variants,
  ) async {
    try {
      final payload = {
        'p_id_base': base.id,
        'p_sku_base': base.baseSku.trim().isEmpty ? null : base.baseSku.trim(),
        'p_categoria': base.category,
        'p_subcategoria': base.subcategory,
        'p_descripcion': base.description,
        'p_variantes': variants.map((v) {
          return {
            'id': v.id,
            'sku': v.sku.trim().isEmpty ? null : v.sku.trim(),
            'stock': v.stock,
            'costPrice': v.costPrice,
            'salePrice': v.salePrice,
            'color': v.color,
            'size': v.size,
            'measurementUnit': v.measurementUnit.dbValue,
            'recipe': v.manufacturingRecipe.map((r) {
              return {
                'rawMaterialId': r.rawMaterial.id,
                'quantity': r.quantity,
              };
            }).toList(),
          };
        }).toList(),
      };

      await supabaseClient.rpc('actualizar_producto_completo', params: payload);
    } catch (e) {
      throw Exception('Error al actualizar el producto completo: $e');
    }
  }

  Future<void> deleteProductWithVariants(int id) async {
    await supabaseClient.rpc(
      'eliminar_producto_completo',
      params: {'p_idproducto_base': id},
    );
  }

  Future<void> deleteVariant(int id) async {
    await supabaseClient.rpc(
      'eliminar_producto_variante',
      params: {'p_idproducto_variante': id},
    );
  }

  Future<void> updateStock(int variantId, double delta, bool deductMp) async {
    await supabaseClient.rpc(
      'ajustar_stock_producto',
      params: {
        'p_id_variante': variantId,
        'p_cantidad': delta,
        'p_descontar_mp': deductMp,
      },
    );
  }
}
