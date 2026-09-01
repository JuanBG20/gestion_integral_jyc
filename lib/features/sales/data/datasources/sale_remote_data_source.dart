import 'package:gestion_integral_jyc/core/enums/payment_method.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/discount_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_item_model.dart';
import 'package:gestion_integral_jyc/features/sales/data/models/sale_model.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/discount_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaleRemoteDataSource {
  final SupabaseClient supabaseClient;

  SaleRemoteDataSource(this.supabaseClient);

  Future<List<SaleModel>> fetchSales() async {
    final response = await supabaseClient
        .from('venta')
        .select('''
      *,
      cliente (*),
      venta_trabajo (
        trabajo (
          *,
          cliente (*),
          historial_estado (
            *,
            estado (*)
          ),
          contiene_trabajo (
            *,
            producto_variante (
              *,
              producto_base (*)
            )
          )
        )
      ),
      contiene_venta (
        *,
        producto_variante (
          *,
          producto_base (*)
        )
      ),
      venta_descuento (*),
      factura (*)
    ''')
        .order('fecha', ascending: false);

    return (response as List).map((json) => SaleModel.fromJson(json)).toList();
  }

  Future<int> createSaleRPC(
    SaleModel sale, {
    int? materiaPrimaId,
    double? consumo,
  }) async {
    final payload = {
      'p_cliente': sale.client.id,
      'p_metodo_pago': sale.paymentMethod?.dbValue,
      'p_esta_pagado': sale.isPaid,
      'p_descuentos': sale.discounts
          .map((discount) => (discount as DiscountModel).toJson())
          .toList(),
      'p_id_trabajo': sale.work?.id,
      'p_items': sale.items
          .map((item) => (item as SaleItemModel).toJson())
          .toList(),
      'p_materia_prima': materiaPrimaId,
      'p_consumo': consumo,
    };

    final response = await supabaseClient.rpc(
      'crear_venta_completa',
      params: payload,
    );

    return (response as num).toInt();
  }

  Future<void> markSaleAsPaid(
    int saleId,
    PaymentMethod paymentMethod, {
    List<DiscountEntity> additionalDiscounts = const [],
  }) async {
    await supabaseClient
        .from('venta')
        .update({'esta_pagado': true, 'metodo_pago': paymentMethod.dbValue})
        .eq('idventa', saleId);

    if (additionalDiscounts.isNotEmpty) {
      final discountPayload = additionalDiscounts
          .map(
            (d) => {
              'venta': saleId,
              'motivo': d.reason,
              'monto_descontado': d.amount,
            },
          )
          .toList();

      await supabaseClient.from('venta_descuento').insert(discountPayload);
    }
  }
}
