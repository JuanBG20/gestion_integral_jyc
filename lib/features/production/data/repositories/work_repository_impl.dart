import 'package:gestion_integral_jyc/core/enums/work_state.dart';
import 'package:gestion_integral_jyc/features/production/data/datasources/work_remote_data_source.dart';
import 'package:gestion_integral_jyc/features/production/data/models/partial_payment_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_item_model.dart';
import 'package:gestion_integral_jyc/features/production/data/models/work_model.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/partial_payment_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/entities/work_entity.dart';
import 'package:gestion_integral_jyc/features/production/domain/repositories/work_repository.dart';

class WorkRepositoryImpl implements WorkRepository {
  final WorkRemoteDataSource remoteDataSource;

  WorkRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createWork(WorkEntity work) async {
    final workModel = WorkModel(
      creationDate: work.creationDate,
      deadline: work.deadline,
      client: work.client,
      actualState: work.actualState,
      items: work.items
          .map(
            (i) => WorkItemModel(
              variantProduct: i.variantProduct,
              quantity: i.quantity,
              unitPrice: i.unitPrice,
              isDone: i.isDone,
              description: i.description,
            ),
          )
          .toList(),
      partialPayments: work.partialPayments
          .map(
            (i) => PartialPaymentModel(
              amount: i.amount,
              date: i.date,
              paymentMethod: i.paymentMethod,
            ),
          )
          .toList(),
    );
    await remoteDataSource.createWorkRPC(workModel);
  }

  @override
  Future<List<WorkEntity>> getWorks() async {
    return await remoteDataSource.fetchWorks();
  }

  @override
  Future<void> updateWorkItemDone(int itemId, bool isDone) async {
    await remoteDataSource.updateItemDone(itemId, isDone);
  }

  @override
  Future<void> updateWorkState(int workId, WorkState newState) async {
    await remoteDataSource.updateWorkStateRPC(workId, newState.dbValue);
  }

  @override
  Future<void> updateWork(WorkEntity work) async {
    final workModel = WorkModel(
      id: work.id,
      creationDate: work.creationDate,
      deadline: work.deadline,
      client: work.client,
      actualState: work.actualState,
      items: work.items
          .map(
            (i) => WorkItemModel(
              id: i.id,
              variantProduct: i.variantProduct,
              quantity: i.quantity,
              unitPrice: i.unitPrice,
              isDone: i.isDone,
              description: i.description,
            ),
          )
          .toList(),
      partialPayments: work.partialPayments
          .map(
            (i) => PartialPaymentModel(
              id: i.id,
              amount: i.amount,
              date: i.date,
              paymentMethod: i.paymentMethod,
              workId: work.id,
            ),
          )
          .toList(),
    );
    await remoteDataSource.updateWork(workModel);
  }

  @override
  Future<void> addPartialPayment(PartialPaymentEntity payment) async {
    final paymentModel = PartialPaymentModel(
      amount: payment.amount,
      date: payment.date,
      paymentMethod: payment.paymentMethod,
      workId: payment.workId,
    );
    await remoteDataSource.insertPartialPayment(paymentModel);
  }
}
