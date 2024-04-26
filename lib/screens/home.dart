import 'dart:ui';

import 'package:extrack/widgets/expenseCard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../provider/expensesProvider.dart';
import '../widgets/expenseCard.dart';

class Home extends StatefulWidget {
  Function viewExpenses;
  double availableAmount;
  static const routeName = '/home';

  Home({
    Key? key,
    required this.viewExpenses,
    required this.availableAmount,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print('home rebuilt');

    // var deviceData = MediaQuery.of(context);
    final expensesData = Provider.of<ExpensesProvider>(context);
    final Map<String, List<Expense>> expenses = expensesData.getAllExpense();
    final double availableBal =
        expensesData.maxAmt - expensesData.totalExpenseAmt;
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 100)),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dx < -20) {
                  widget.viewExpenses(1);
                }
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      /*gradient: LinearGradient(colors: [
                Colors.black,
                Colors.blueAccent,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),*/
                      //borderRadius: BorderRadius.circular(50),
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.18,
                    padding:
                        const EdgeInsets.only(top: 10, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              /*
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 201, 48, 37),
                        Color.fromARGB(255, 42, 219, 110),
                        Color.fromARGB(255, 22, 128, 214),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),*/
                              // color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Available balance',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  // '₹${widget.availableAmount}',
                                  '₹${availableBal}',
                                  //textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // height: deviceData.size.height * 0.6,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Container(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        // height: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Recent expenses',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      widget.viewExpenses(2);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Theme.of(context).colorScheme.primary,
                                      padding: const EdgeInsets.all(5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        'View all',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: recentExpenses(
                                  expenses,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        }));
  }
}

List<Widget> recentExpenses(Map<String, List<Expense>> tr) {
  int recentCount = 0;
  List<Widget> list = [];

  tr.forEach((key, value) {
    if (recentCount == 7) {
      return;
    }

    if (value.isNotEmpty) {
      list.add(
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 65, 65, 65),
            borderRadius: BorderRadius.circular(10),
            /*  gradient: LinearGradient(
              colors: [
                Colors.black,
              ],
            ),*/
          ),
          child: Text(
            key,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      recentCount++;
    }

    for (var ex in value) {
      list.add(ExpenseCard(
        expense: ex,
      ));
    }
  });

  return list;
}
