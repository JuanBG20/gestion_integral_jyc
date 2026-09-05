import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/features/sales/domain/entities/sale_entity.dart';
import 'package:go_router/go_router.dart';

void handleSaleSharedAction(
  BuildContext context,
  String action,
  SaleEntity sale,
) {
  switch (action) {
    case 'detail':
      context.go('/sales/detail', extra: sale);
    case 'bill':
      context.go('/sales/detail/bill', extra: sale);
  }
}
