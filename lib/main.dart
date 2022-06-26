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
    '6/25/2022': [
      Transaction(
        amount: 50,
        date: DateTime.now(),
        title: 'purchased milk',
        category: 'food',
        amountType: 'debit',
      ),
      Transaction(
        amount: 550,
        date: DateTime.now(),
        title: 'bought battlefield 5',
        amountType: 'debit',
        category: 'entertainment',
      ),
      Transaction(
          amount: 1400,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'watched doctor strange in imax',
          category: 'entertainment'),
      Transaction(
          amount: 290,
          amountType: 'debit',
          date: DateTime.now(),
          title: 'bought polo tshirt',
          category: 'cloth'),
    ],
    '6/23/2022': [
      Transaction(
          amount: 110,
          date: DateTime.now(),
          title: 'bike petrol 1L',
          amountType: 'debit',
          category: 'others'),
      Transaction(
          amount: 652,
          date: DateTime.now(),
          amountType: 'debit',
          title: 'bought medicine ',
          category: 'health'),
      Transaction(
          amount: 540,
          date: DateTime.now(),
          title: 'ordered via zomato',
          amountType: 'debit',
          category: 'food'),
      Transaction(
        amount: 520,
        date: DateTime.now(),
        title: 'bought jeans(black)',
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
    '5/13/2022': [
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '2/13/2022': [
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '12/13/2022': [
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '9/13/2022': [
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '1/13/2022': [
      Transaction(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ]
  };

  int selectedPageId = 1;

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
        /*
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Chart',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
          ),
        ),
       appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),*/
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
