class Transaction {
  final int amount;
  final String amountType;
  final String title;
  final DateTime date;
  final String category;

  Transaction({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    required this.amountType,
  });
}
