import 'dart:convert';
import 'dart:html';

import 'package:extrack/addNewExpense.dart';
import 'package:extrack/splash.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './chart.dart';
import './home.dart';
import './category.dart';
import './settings.dart';
import 'userAllExpenses.dart';

import 'models/expense.dart';
import './splash.dart';

// ...
/*
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
*/

void main() {
  runApp(wid());
}

class wid extends StatefulWidget {
  wid({Key? key}) : super(key: key);

  @override
  State<wid> createState() => _widState();
}

class _widState extends State<wid> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        //  routes: {'/addNew': (context) => AddExpense(this._addExpenseToMap)},
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(fontFamily: 'Lato', fontSize: 20),
          ),
          fontFamily: 'Quicksand',
          scrollbarTheme: ScrollbarThemeData(
            crossAxisMargin: 3,
            mainAxisMargin: 10,
            radius: const Radius.circular(50),
            thickness: MaterialStateProperty.all(5),
            thumbColor: MaterialStateProperty.all(
              Color.fromARGB(255, 56, 56, 56),
            ),
          ),
        ),
        home: FutureBuilder(
          future: splash(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashPage();
            }
            if (snapshot.hasData) {
              return MyApp();
            }

            return SplashPage();
          },
        ));
  }
}

Future<bool> splash() async {
  await Future.delayed(Duration(milliseconds: 900));
  return true;
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _monthlyIncome = 50000;
  double totalExpanseAmount = 0;
  double availableAmount = 40;

  Map<String, List<Expense>> expenses = {
    '6/25/2022': [
      Expense(
        amount: 50,
        date: DateFormat.yMd().parse('6/25/2022'),
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
    ],
    '6/23/2022': [
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
          category: 'health'),
      Expense(
          amount: 540,
          date: DateTime.now(),
          title: 'ordered via zomato',
          amountType: 'debit',
          category: 'food'),
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
        category: 'others',
      ),
    ],
    '5/13/2022': [
      Expense(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '2/13/2022': [
      Expense(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
    '7/6/2022': [
      Expense(
        amount: 2220,
        date: DateTime.now(),
        title: 'zomato refund',
        amountType: 'credit',
        category: 'others',
      ),
    ],
  };

  int selectedPageId = 0;

  List<bool> bottomBarItemSelected = [true, false, false, false];

  void _changeSelectedItem(int pageId) {
    setState(() {
      for (int i = 0; i < 4; i++) {
        if (i == pageId)
          bottomBarItemSelected[i] = true;
        else
          bottomBarItemSelected[i] = false;
      }
    });
  }

  late List<Widget> widgets;

  _selectPage(int pageId) {
    setState(() {
      selectedPageId = pageId;
    });
  }

  _updateAmt() {
    availableAmount = _monthlyIncome - totalExpanseAmount;

    print('total expen updated:$totalExpanseAmount');
    print('avail amt updated:$availableAmount');
  }

  @override
  void initState() {
    super.initState();
    getTotalExpense(expenses).then((value) {
      totalExpanseAmount = value;
      availableAmount = _monthlyIncome - totalExpanseAmount;
    });
  }

  _addExpenseToMap(Expense ex) async {
    String exDate = DateFormat.yMd().format(ex.date);

    if (expenses.containsKey(exDate)) {
      expenses[exDate]?.add(ex);
    } else {
      expenses.addEntries([
        MapEntry(exDate, [ex])
      ]);
    }
    double newExpenseAmt = await getTotalExpense(expenses).then(
      (value) => value,
    );
    setState(() {
      this.totalExpanseAmount = newExpenseAmt;
      this._updateAmt();
    });
  }

  List<String> categorylist = [
    'cloth',
    'food',
    'entertainment',
    'health',
    'others',
    'shopping',
    'gift',
    'bills',
    'electronics',
    'travel'
  ];

  @override
  Widget build(BuildContext context) {
    widgets = [
      Home(
        expenses: expenses,
        viewExpenses: _selectPage,
        availableAmount: availableAmount,
      ),
      Chart(
        expenses: expenses,
        categorylist: categorylist,
      ),
      Category(
        expenses: expenses,
      ),
      UserAllExpenses(
        expenses: expenses,
      )
    ];
    print('myapp rebuilt');
    return Scaffold(
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
        shape: const CircularNotchedRectangle(),
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
                _selectPage,
                0,
                _changeSelectedItem,
                bottomBarItemSelected[0],
              ),
              customBottomBarItem(
                Icons.donut_small_outlined,
                'Chart',
                _selectPage,
                1,
                _changeSelectedItem,
                bottomBarItemSelected[1],
              ),
              SizedBox(
                width: 40,
              ),
              customBottomBarItem(
                Icons.category_rounded,
                'Category',
                _selectPage,
                2,
                _changeSelectedItem,
                bottomBarItemSelected[2],
              ),
              customBottomBarItem(
                Icons.list_alt_rounded,
                'Expenses',
                _selectPage,
                3,
                _changeSelectedItem,
                bottomBarItemSelected[3],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpense(
                addToList: this._addExpenseToMap,
                categorylist: categorylist,
              ),
            ),
          );
        },
        child: Container(
          child: const Icon(Icons.add),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60), color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Future<double> getTotalExpense(Map<String, List<Expense>> tr) async {
  double amount = 0;
  int currentMonth = int.parse(DateFormat.M().format(DateTime.now()));

  for (MapEntry e in tr.entries) {
    int month = DateFormat('M/dd/yy').parse(e.key).month;
    if (month == currentMonth) {
      await e.value.forEach((t) {
        amount += t.amount;
      });
    }
  }

  return amount;
}

Container customBottomBarItem(IconData icon, String label, Function selectPage,
    int selectPageId, Function changeSelectedItem, bool isSelected) {
  return Container(
    margin: const EdgeInsets.all(5),
    alignment: Alignment.center,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(5),
        primary: isSelected ? Colors.black : Colors.white,
        elevation: isSelected ? 10 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
