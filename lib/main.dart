import 'package:flutter/material.dart';

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
  Map<String, List<Transaction>> transactions = {
    '6/23/2022': [
      Transaction(
        amount: 50,
        date: DateTime.now(),
        title: 'milk',
        category: 'food',
      ),
      Transaction(
          amount: 550,
          date: DateTime.now(),
          title: 'gta',
          category: 'entertainment'),
      Transaction(
          amount: 400,
          date: DateTime.now(),
          title: 'cod',
          category: 'entertainment'),
      Transaction(
          amount: 290,
          date: DateTime.now(),
          title: 'tshirt',
          category: 'cloth'),
    ],
    '6/25/2022': [
      Transaction(
          amount: 142, date: DateTime.now(), title: 'bike', category: 'fuel'),
      Transaction(
          amount: 652,
          date: DateTime.now(),
          title: 'fever',
          category: 'health'),
      Transaction(
          amount: 540, date: DateTime.now(), title: 'lays', category: 'food'),
      Transaction(
          amount: 520, date: DateTime.now(), title: 'jeans', category: 'cloth'),
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
    widgets = [
      Home(
        transactions: transactions,
        viewTransactions: selectPage,
      ),
      Chart(transactions: transactions),
      Category(
        transactions: transactions,
      ),
      UserTransactions(
        transactions: transactions,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
