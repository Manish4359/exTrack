import 'dart:convert';

import 'package:extrack/expenseActions.dart';
import 'package:extrack/provider/expensesProvider.dart';
import 'package:extrack/screens/viewExpense.dart';
import 'package:extrack/widgets/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'screens/chart.dart';
import 'screens/home.dart';
import 'screens/userProfile.dart';
import 'screens/userAllExpenses.dart';

import 'models/expense.dart';
import 'widgets/splash.dart';
import 'screens/signinAndSignup.dart';

import 'provider/expensesProvider.dart';
import './constant.dart';

// ...
/*
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.userChanges().listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(wid());
}

class wid extends StatefulWidget {
  wid({Key? key}) : super(key: key);

  @override
  State<wid> createState() => _widState();
}

class _widState extends State<wid> {
  bool signedin = false;

  userSigned() async {
    setState(() {
      signedin = !signedin;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser);
      userSigned();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpensesProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/signup': (context) => SignUp(
                userSigned: userSigned,
              ),
          '/signin': (context) => SignIn(userSigned: userSigned),
          '/chart': (context) => SignIn(userSigned: userSigned),
          //ViewExpense.routeName: (context) => ViewExpense()
        },
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(fontFamily: 'Lato', fontSize: 20),
          ),
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
            primary: const Color.fromARGB(255, 231, 42, 42),
            secondary: const Color.fromARGB(255, 65, 65, 65),
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
              return signedin
                  ? Consumer<ExpensesProvider>(
                      builder: (context, expensesData, child) => MyApp(
                            userSigned: userSigned,
                            getTotalExpAmt: expensesData.getTotalExpenseAmount,
                          ))
                  : SignIn(
                      userSigned: userSigned,
                    );
            }

            return SplashPage();
          },
        ),
      ),
    );
  }
}

Future<bool> splash() async {
//  await Future.delayed(Duration(milliseconds: 1500));
  return true;
}

class MyApp extends StatefulWidget {
  VoidCallback userSigned;
  Function getTotalExpAmt;
  MyApp({Key? key, required this.userSigned, required this.getTotalExpAmt})
      : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _monthlyIncome = 50000;
  late double totalExpanseAmount = widget.getTotalExpAmt();
  double availableAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateAmt();
  }

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
    _changeSelectedItem(pageId);
  }

  _updateAmt() {
    totalExpanseAmount = widget.getTotalExpAmt();
    availableAmount = _monthlyIncome - totalExpanseAmount;

    print('total expen updated:$totalExpanseAmount');
    print('avail amt updated:$availableAmount');
  }

/*
  _addExpenseToMap(Expense ex) async {
    String exDate = DateFormat.yMd().format(ex.date);

    await ExpensesProvider.addExpense(ex);
    double newExpenseAmt =
        await ExpensesProvider.getMonthlyExpenseAmount(exDate);
    setState(() {
      this.totalExpanseAmount = newExpenseAmt;
      this._updateAmt();
    });
  }

  _deleteExpenseFromMap(Expense ex) async {
    await ExpensesProvider.deleteExpense(ex);
    this._updateAmt();
    setState(() {});
  }

  _saveExpense(Map<String, dynamic> editExpense, DateTime date, int id) async {
    await ExpensesProvider.editExpense(editExpense, date, id);
    this._updateAmt();
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpensesProvider>(context);

    widgets = [
      Home(
        viewExpenses: _selectPage,
        availableAmount: availableAmount,
      ),
      Chart(),
      UserAllExpenses(),
      Profile(userSigned: widget.userSigned),
    ];
    print('myapp rebuilt');
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 231, 42, 42),
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
              CustomBottomBarItem(
                icon: Icons.home,
                label: 'Home',
                selectPage: _selectPage,
                changeSelectedItem: _changeSelectedItem,
                isSelected: bottomBarItemSelected[0],
                selectPageId: 0,
              ),
              CustomBottomBarItem(
                icon: Icons.donut_small_outlined,
                label: 'Chart',
                selectPage: _selectPage,
                changeSelectedItem: _changeSelectedItem,
                isSelected: bottomBarItemSelected[1],
                selectPageId: 1,
              ),
              SizedBox(
                width: 40,
              ),
              CustomBottomBarItem(
                icon: Icons.list_alt_rounded,
                label: 'Expenses',
                selectPage: _selectPage,
                changeSelectedItem: _changeSelectedItem,
                isSelected: bottomBarItemSelected[2],
                selectPageId: 2,
              ),
              CustomBottomBarItem(
                icon: Icons.person,
                label: 'Profile',
                selectPage: _selectPage,
                changeSelectedItem: _changeSelectedItem,
                isSelected: bottomBarItemSelected[3],
                selectPageId: 3,
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
              builder: (context) => AddExpense(),
            ),
          );
        },
        child: Container(
          child: const Icon(Icons.add),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Theme.of(context).colorScheme.secondary),
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

class CustomBottomBarItem extends StatelessWidget {
  IconData icon;
  String label;
  Function selectPage;
  int selectPageId;
  Function changeSelectedItem;
  bool isSelected;
  CustomBottomBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.selectPage,
    required this.changeSelectedItem,
    required this.isSelected,
    required this.selectPageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(5),
          primary:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          elevation: isSelected ? 10 : 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.secondary,
            ),
            Text(
              label,
              style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
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
}
