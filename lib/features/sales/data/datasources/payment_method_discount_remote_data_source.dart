import 'package:gestion_integral_jyc/features/sales/data/models/payment_method_discount_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentMethodDiscountRemoteDataSource {
  final SupabaseClient supabaseClient;

  PaymentMethodDiscountRemoteDataSource(this.supabaseClient);

  Future<List<PaymentMethodDiscountModel>> fetchAll() async {
    final response = await supabaseClient
        .from('descuento_metodo_pago')
        .select();
    return (response as List)
        .map((json) => PaymentMethodDiscountModel.fromJson(json))
        .toList();
  }

  Future<void> upsert(PaymentMethodDiscountModel model) async {
    await supabaseClient
        .from('descuento_metodo_pago')
        .upsert(model.toJson(), onConflict: 'user_id,metodo_pago');
  }
}
