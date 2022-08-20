import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

class ExpensesProvider with ChangeNotifier {
  Map<String, List<Expense>> _expenses = {
    '8/19/2022': [
      Expense(
        amount: 50,
        date: DateFormat.yMd().parse('8/19/2022'),
        title: 'purchased milk',
        category: 'food',
        amountType: 'debit',
      ),
      Expense(
        amount: 550,
        date: DateFormat.yMd().parse('8/19/2022'),
        title: 'bought battlefield 5',
        amountType: 'debit',
        category: 'entertainment',
      ),
      Expense(
          amount: 1400,
          amountType: 'debit',
          date: DateFormat.yMd().parse('8/19/2022'),
          title: 'watched doctor strange in imax',
          category: 'entertainment'),
      Expense(
          amount: 290,
          amountType: 'debit',
          date: DateFormat.yMd().parse('8/19/2022'),
          title: 'bought polo tshirt',
          category: 'cloth'),
      Expense(
          amount: 110,
          date: DateFormat.yMd().parse('8/19/2022'),
          title: 'bike petrol 1L',
          amountType: 'debit',
          category: 'others'),
      Expense(
          amount: 652,
          date: DateFormat.yMd().parse('8/19/2022'),
          amountType: 'debit',
          title: 'bought medicine ',
          category: 'gift'),
      Expense(
          amount: 540,
          date: DateFormat.yMd().parse('8/19/2022'),
          title: 'ordered via zomato',
          amountType: 'debit',
          category: 'shopping'),
      Expense(
        amount: 520,
        date: DateFormat.yMd().parse('8/19/2022'),
        title: 'bought jeans(black)',
        amountType: 'debit',
        category: 'cloth',
      ),
      Expense(
        amount: 2220,
        date: DateFormat.yMd().parse('8/19/2022'),
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

  getAllExpense() {
    return {..._expenses};
  }

  addExpense(ex) {
    String exDate = DateFormat.yMd().format(ex.date);

    if (_expenses.containsKey(exDate)) {
      _expenses[exDate]?.insert(0, ex);
    } else {
      _expenses.addEntries([
        MapEntry(exDate, [ex])
      ]);
    }
    notifyListeners();
  }

  editExpense(Map<String, dynamic> ex) {
    String date = DateFormat.yMd().format(ex['date']);

    if (_expenses.containsKey(date)) {
      _expenses[date]!.forEach(
        (expense) {
          print('saving ${ex['id']} ${expense.id}');
          if (expense.id == ex['id']) {
            print('saved');

            expense.title = ex['title'];
            expense.amount = ex['amount'];
            expense.category = ex['category'];
          }
        },
      );
    }
    notifyListeners();
  }

  deleteExpense(Expense ex) {
    String date = DateFormat.yMd().format(ex.date);
    print(date + " " + '${_expenses.containsKey(date)}');

    print('${ex.id} ${ex.title}');

    _expenses[date]!.remove(ex);

    if (_expenses[date]!.length == 0) {
      _expenses.remove(date);
    }
    notifyListeners();
  }

  double getTotalExpenseAmount() {
    double amount = 0;

    for (MapEntry e in _expenses.entries) {
      amount += getMonthlyExpenseAmount(e.key);
    }

    return amount;
  }

  double getMonthlyExpenseAmount(String date) {
    double amount = 0;
    _expenses[date]!.forEach((t) {
      amount += t.amount;
    });

    return amount;
  }
}
