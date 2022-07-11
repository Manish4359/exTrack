import 'package:intl/intl.dart';

import './expense.dart';

class ExpensesData {
  static Map<String, List<Expense>> expenses = {
    DateFormat.yMd().format(DateTime.now()): [
      Expense(
        amount: 50,
        date: DateTime.now(),
        title: 'purchased milk',
        category: 'food',
        amountType: 'debit',
      ),
      Expense(
        amount: 550,
        date: DateTime.now(),
        title: 'bought battlefield 5',
        amountType: 'debit',
        category: 'entertainment',
      ),
      Expense(
          amount: 1400,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'watched doctor strange in imax',
          category: 'entertainment'),
      Expense(
          amount: 290,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'bought polo tshirt',
          category: 'cloth'),
      Expense(
          amount: 110,
          date: DateTime.now(),
          title: 'bike petrol 1L',
          amountType: 'debit',
          category: 'others'),
      Expense(
          amount: 652,
          date: DateTime.now(),
          amountType: 'debit',
          title: 'bought medicine ',
          category: 'gift'),
      Expense(
          amount: 540,
          date: DateTime.now(),
          title: 'ordered via zomato',
          amountType: 'debit',
          category: 'shopping'),
      Expense(
        amount: 520,
        date: DateTime.now(),
        title: 'bought jeans(black)',
        amountType: 'debit',
        category: 'cloth',
      ),
      Expense(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'travel',
      ),
    ],
    '7/3/2022': [
      Expense(
        amount: 2220,
        date: DateFormat.yMd().parse('7/3/2022'),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'bills',
      ),
      Expense(
          amount: 652,
          date: DateFormat.yMd().parse('7/3/2022'),
          amountType: 'debit',
          title: 'bought medicine ',
          category: 'gift'),
      Expense(
          amount: 540,
          date: DateFormat.yMd().parse('7/3/2022'),
          title: 'ordered via zomato',
          amountType: 'debit',
          category: 'shopping'),
      Expense(
        amount: 520,
        date: DateFormat.yMd().parse('7/3/2022'),
        title: 'bought jeans(black)',
        amountType: 'debit',
        category: 'cloth',
      ),
    ],
    '2/13/2022': [
      Expense(
        amount: 2220,
        date: DateFormat.yMd().parse('2/13/2022'),
        title: 'bhimupi refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '7/6/2022': [
      Expense(
        amount: 2220,
        date: DateFormat.yMd().parse('7/6/2022'),
        title: 'googlepay refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
  };

  static addExpense(ex) {
    String exDate = DateFormat.yMd().format(ex.date);

    if (ExpensesData.expenses.containsKey(exDate)) {
      ExpensesData.expenses[exDate]?.insert(0, ex);
    } else {
      ExpensesData.expenses.addEntries([
        MapEntry(exDate, [ex])
      ]);
    }
  }

  static editExpense() {}

  static deleteExpense(Expense ex) {
    String date = DateFormat.yMd().format(ex.date);
    print(date + " " + '${expenses.containsKey(date)}');

    print('${ex.id} ${ex.title}');

    expenses[date]!.remove(ex);

    if (expenses[date] == []) {
      expenses.remove(date);
    }
  }

  static double getTotalExpenseAmount() {
    double amount = 0;

    for (MapEntry e in expenses.entries) {
      amount += getMonthlyExpenseAmount(e.key);
    }

    return amount;
  }

  static double getMonthlyExpenseAmount(String date) {
    double amount = 0;
    expenses[date]!.forEach((t) {
      amount += t.amount;
    });

    return amount;
  }
}
