import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/expense.dart';

class Home extends StatefulWidget {
  final Map<String, List<Expense>> expenses;
  Function viewExpenses;
  double availableAmount;

  Home({
    Key? key,
    required this.expenses,
    required this.viewExpenses,
    required this.availableAmount,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    print('home updated');

    // var deviceData = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.20,
          padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
          // margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Available balance',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                '₹${widget.availableAmount}',
                //textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black,
            /*gradient: LinearGradient(colors: [
                Colors.black,
                Colors.blueAccent,
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),*/
            //borderRadius: BorderRadius.circular(50),
          ),
        ),
        Expanded(
          child: Container(
            // height: deviceData.size.height * 0.6,
            color: Colors.black,
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              // height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                  color: Colors.white),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent expenses',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.viewExpenses(3);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Container(
                              padding: EdgeInsets.all(5),
                              child: const Text(
                                'View all',
                              )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: recentTr(widget.expenses),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

Card transactionCard(Expense expense) {
  return Card(
    clipBehavior: Clip.hardEdge,
    color: const Color.fromARGB(255, 247, 247, 247),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 55,
          width: 55,
          child: Image.asset('assets/images/${expense.category}.png'),
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${DateFormat.yMd().format(expense.date)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${expense.title}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            //height: double,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10), color: Colors.blue
                ),
            child: Text(
              '₹${expense.amount}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  //   color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: expense.amountType == 'debit'
                      ? Colors.red
                      : Colors.green),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Card> recentTr(Map<String, List<Expense>> tr) {
  int recentCount = 0;
  List<Card> list = [];

  tr.forEach((key, value) {
    if (recentCount == 7) {
      return;
    }

    if (value.isNotEmpty) {
      list.add(
        Card(
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              '$key',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          color: const Color.fromARGB(255, 65, 65, 65),
        ),
      );
      recentCount++;
    }

    value.forEach((tr) {
      list.add(transactionCard(tr));
    });
  });

  return list;
}
