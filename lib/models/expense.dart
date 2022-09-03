import 'dart:math';

class Expense {
  int amount;
  String amountType;
  String title;
  final DateTime date;
  String category;

  int id = DateTime.now()
      .difference(DateTime(2022, DateTime.january, 1))
      .inMicroseconds;

  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    required this.amountType,
  });

  setId(id) {
    this.id = id;
  }
}
