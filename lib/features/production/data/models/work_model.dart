import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/clients/data/models/client_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/partial_payment_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_item_model.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';

class WorkModel extends WorkEntity {
  WorkModel({
    super.id,
    required super.creationDate,
    required super.deadline,
    required super.client,
    required super.actualState,
    required super.items,
    required super.partialPayments,
  });

  factory WorkModel.fromJson(Map<String, dynamic> json) {
    // Determinar el estado actual
    WorkState currentState = WorkState.recibido;
    if (json['historial_estado'] != null &&
        (json['historial_estado'] as List).isNotEmpty) {
      final historial = List<Map<String, dynamic>>.from(
        json['historial_estado'],
      );
      historial.sort(
        (a, b) =>
            DateTime.parse(b['fecha']).compareTo(DateTime.parse(a['fecha'])),
      );

      final estadoNombre = historial.first['estado']['nombre'];
      currentState = WorkState.fromDB(estadoNombre);
    }

    final itemsList =
        (json['contiene_trabajo'] as List?)
            ?.map((itemJson) => WorkItemModel.fromJson(itemJson))
            .toList() ??
        [];

    final partialPaymentsList =
        (json['pago_parcial'] as List?)
            ?.map((itemJson) => PartialPaymentModel.fromJson(itemJson))
            .toList() ??
        [];

    return WorkModel(
      id: json['idtrabajo'],
      creationDate: DateTime.parse(json['fecha_creacion']),
      deadline: json['fecha_limite'] != null
          ? DateTime.parse(json['fecha_limite'])
          : null,
      client: ClientModel.fromJson(json['cliente']),
      actualState: currentState,
      items: itemsList,
      partialPayments: partialPaymentsList,
    );
  }
}
