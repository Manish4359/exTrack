import 'dart:math';

class Expense {
  final int amount;
  final String amountType;
  final String title;
  final DateTime date;
  final String category;
  final int id = DateTime.now()
      .difference(DateTime(2021, DateTime.january, 1))
      .inMicroseconds;

  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    required this.amountType,
  });
}
