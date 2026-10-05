class ExpenseEntity {
  final int? id;
  final String description;
  final String category;
  final double amount;
  final DateTime date;
  final bool isRecurring;

  ExpenseEntity({
    this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
    this.isRecurring = false,
  });
}
