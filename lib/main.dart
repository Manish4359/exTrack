import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart.dart';
import './home.dart';
import './category.dart';
import './settings.dart';
import './transactions.dart';

import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double monthlyIncome = 50000;
  double totalExpanse = 0;
  late double availableAmount;

  Map<String, List<Transaction>> transactions = {
    '6/23/2022': [
      Transaction(
          amount: 50,
          date: DateTime.now(),
          title: 'milk',
          category: 'food',
          amountType: 'debit'),
      Transaction(
        amount: 550,
        date: DateTime.now(),
        title: 'gta',
        amountType: 'debit',
        category: 'entertainment',
      ),
      Transaction(
          amount: 400,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'cod',
          category: 'entertainment'),
      Transaction(
          amount: 290,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'tshirt',
          category: 'cloth'),
    ],
    '6/25/2022': [
      Transaction(
          amount: 142,
          date: DateTime.now(),
          title: 'bike',
          amountType: 'debit',
          category: 'others'),
      Transaction(
          amount: 652,
          date: DateTime.now(),
          amountType: 'debit',
          title: 'fever',
          category: 'health'),
      Transaction(
          amount: 540,
          date: DateTime.now(),
          title: 'lays',
          amountType: 'debit',
          category: 'food'),
      Transaction(
        amount: 520,
        date: DateTime.now(),
        title: 'jeans',
        amountType: 'debit',
        category: 'cloth',
      ),
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
  };

  int selectedPageId = 0;

  selectPage(int pageId) {
    setState(() {
      selectedPageId = pageId;
    });
  }

  late List<Widget> widgets;

  _MyAppState() {
    totalExpanse = getTotalExpense(transactions);

    availableAmount = monthlyIncome - totalExpanse;
    widgets = [
      Home(
          transactions: transactions,
          viewTransactions: selectPage,
          availableAmount: availableAmount),
      Chart(
        transactions: transactions,
        totalExpanse: totalExpanse,
      ),
      Category(
        transactions: transactions,
      ),
      UserTransactions(
        transactions: transactions,
      )
    ];
  }

  changeExpenseAmount(double amt) {
    setState(() {
      totalExpanse = amt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'Lato', fontSize: 20),
        ),
        fontFamily: 'Quicksand',
        scrollbarTheme: ScrollbarThemeData(
          crossAxisMargin: 3,
          mainAxisMargin: 10,
          radius: Radius.circular(50),
          thickness: MaterialStateProperty.all(5),
          thumbColor: MaterialStateProperty.all(
            Color.fromARGB(255, 56, 56, 56),
          ),
        ),
      ),
      home: Scaffold(
        // appBar: AppBar(backgroundColor: Colors.red),
        body: SafeArea(child: widgets.elementAt(selectedPageId)),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline_rounded), label: 'graph'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_rounded), label: 'category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_drop_up_sharp), label: 'transactions'),
          ],
          currentIndex: selectedPageId,
          elevation: 40,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.blue,
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 30),
          selectedItemColor: Color.fromARGB(255, 255, 121, 121),
          onTap: (id) {
            selectPage(id);
          },
        ),
      ),
    );
  }
}

double getTotalExpense(Map<String, List<Transaction>> tr) {
  double amount = 0;
  int currentMonth = int.parse(DateFormat.M().format(DateTime.now()));

  tr.forEach((date, list) {
    int month = DateFormat('M/dd/yy').parse(date).month;
    if (month == currentMonth) {
      list.forEach((t) {
        amount += t.amount;
      });
    }
  });

  return amount;
}
