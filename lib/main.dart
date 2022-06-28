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

  int selectedPageId = 0;

  List<bool> bottomBarItemSelected = [true, false, false, false];

  void changeSelectedItem(int pageId) {
    setState(() {
      for (int i = 0; i < 4; i++) {
        if (i == pageId)
          bottomBarItemSelected[i] = true;
        else
          bottomBarItemSelected[i] = false;
      }
    });
  }

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
        //  backgroundColor: Colors.black,
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
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.hardEdge,
          notchMargin: 5,
          //  color: Colors.green,
          shape: CircularNotchedRectangle(),
          elevation: 40,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customBottomBarItem(
                  Icons.home,
                  'Home',
                  selectPage,
                  0,
                  changeSelectedItem,
                  bottomBarItemSelected[0],
                ),
                customBottomBarItem(
                  Icons.pie_chart_outline_rounded,
                  'Graph',
                  selectPage,
                  1,
                  changeSelectedItem,
                  bottomBarItemSelected[1],
                ),
                SizedBox(
                  width: 40,
                ),
                customBottomBarItem(
                  Icons.category_rounded,
                  'Category',
                  selectPage,
                  2,
                  changeSelectedItem,
                  bottomBarItemSelected[2],
                ),
                customBottomBarItem(
                  Icons.list_alt_rounded,
                  'Expenses',
                  selectPage,
                  3,
                  changeSelectedItem,
                  bottomBarItemSelected[3],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 50,
          onPressed: () {},
          child: Container(
            child: Icon(Icons.add),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60), color: Colors.black),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        /*
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline_rounded), label: 'Graph'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_rounded), label: 'Category'),
            BottomNavigationBarItem(
                icon: Icon(Icons.arrow_drop_up_sharp), label: 'Transactions'),
          ],
          currentIndex: selectedPageId,
          elevation: 40,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.blue,
          showUnselectedLabels: false,
          selectedIconTheme: IconThemeData(size: 30),
          selectedItemColor: Color.fromARGB(255, 255, 121, 121),
          onTap: (id) {
            selectPage(id);
          },
        ),
        */
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

Container customBottomBarItem(IconData icon, String label, Function selectPage,
    int selectPageId, Function changeSelectedItem, bool isSelected) {
  return Container(
    padding: EdgeInsets.all(5),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
        primary: isSelected ? Colors.black : Colors.white,
        elevation: isSelected ? 10 : 0,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.black,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          )
        ],
      ),
      onPressed: () {
        selectPage(selectPageId);
        changeSelectedItem(selectPageId);
      },
    ),
  );
}
