import 'package:gestion_integral_jyc/features/inventory/domain/entities/price_preview_entity.dart';

abstract class PricePreviewRepository {
  Future<List<PricePreviewEntity>> getPricePreview();
  Future<void> confirmNewPrice(List<int> ids);
}
