import 'package:gestion_integral_jyc/features/inventory/data/models/base_product_model.dart';
import 'package:gestion_integral_jyc/features/inventory/data/models/variant_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProductRemoteDataSource(this.supabaseClient);

  Future<List<Map<String, dynamic>>> fetchInventoryWithVariants() async {
    final response = await supabaseClient.from('producto_base').select('''
      *,
      producto_variante (*)
    ''');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createFullProductRPC(
    BaseProductModel base,
    List<VariantProductModel> variants,
  ) async {
    final payload = {
      'p_sku_base': base.baseSku,
      'p_categoria': base.category,
      'p_subcategoria': base.subcategory,
      'p_descripcion': base.description,
      'p_variantes': variants
          .map(
            (v) => {
              'sku': v.sku,
              'stock': v.stock,
              'costPrice': v.costPrice,
              'salePrice': v.salePrice,
              'color': v.color,
              'size': v.size,
            },
          )
          .toList(),
    };

    await supabaseClient.rpc('crear_producto_completo', params: payload);
  }

  Future<void> insertRecipe(
    int variantId,
    int rawMaterialId,
    double quantity,
  ) async {
    await supabaseClient.from('fabrica').insert({
      'producto_variante': variantId,
      'materia_prima': rawMaterialId,
      'cantidad': quantity,
    });
  }
}
