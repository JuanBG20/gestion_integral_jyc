class DiscountEntity {
  final int? id;
  final String reason;
  final double amount;

  DiscountEntity({required this.reason, required this.amount, this.id});
}
