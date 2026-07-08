import 'package:flutter/material.dart';
import 'package:gestion_integral_jyc/core/domain/entities/client_entity.dart';
import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/core/presentation/widgets/layout.dart';
import 'package:gestion_integral_jyc/core/theme/app_theme.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/base_product_entity.dart';
import 'package:gestion_integral_jyc/features/inventory/domain/entities/variant_product_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_item_entity.dart';
import 'package:gestion_integral_jyc/features/production/presentation/screens/work_details_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Layout(
          child: WorkDetailsScreen(
            work: WorkEntity(
              creationDate: DateTime.now(),
              deadline: null,
              client: ClientEntity(name: "Juan", lastName: "Bautista"),
              actualState: WorkState.hecho,
              items: [
                WorkItemEntity(
                  quantity: 10,
                  unitPrice: 1500,
                  variantProduct: VariantProductEntity(
                    sku: "ABC",
                    stock: 5,
                    costPrice: 1500,
                    salePrice: 2000,
                    color: "Rojo",
                    size: "10x10",
                    baseProduct: BaseProductEntity(
                      baseSku: 'ABE',
                      category: 'Impresión',
                      subcategory: '3D',
                      description: 'Hola',
                    ),
                    manufacturingRecipe: [],
                  ),
                ),
                WorkItemEntity(
                  quantity: 2,
                  unitPrice: 1500,
                  description: "Chau",
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
