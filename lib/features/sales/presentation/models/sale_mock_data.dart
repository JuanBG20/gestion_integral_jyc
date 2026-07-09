class SaleMockData {
  final String id;
  final String client;
  final String date;
  final String method;
  final double amount;
  final bool hasCae;

  const SaleMockData({
    required this.id,
    required this.client,
    required this.date,
    required this.method,
    required this.amount,
    this.hasCae = false,
  });
}
