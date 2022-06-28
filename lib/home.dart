import 'dart:ui';

import 'package:flutter/material.dart';

import './models/transaction.dart';

class Home extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;
  Function viewTransactions;
  double availableAmount;

  Home({
    Key? key,
    required this.transactions,
    required this.viewTransactions,
    required this.availableAmount,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.25,
          padding: EdgeInsets.only(top: 10, left: 30, right: 30),
          // margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
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
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              // height: double.infinity,
              decoration: BoxDecoration(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent expenses',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.viewTransactions(3);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('view all'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: recentTr(widget.transactions),
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

Card transactionCard(
    String category, String title, int amount, String amountType) {
  return Card(
    clipBehavior: Clip.hardEdge,
    color: Color.fromARGB(255, 247, 247, 247),
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 55,
          width: 55,
          child: Image.asset('assets/images/$category.png'),
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${category.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${title}',
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
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            //height: double,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10), color: Colors.blue
                ),
            child: Text(
              '₹$amount',
              textAlign: TextAlign.center,
              style: TextStyle(
                  //   color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                  color: amountType == 'debit' ? Colors.red : Colors.green),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Card> recentTr(Map<String, List<Transaction>> tr) {
  int recentCount = 0;
  List<Card> list = [];

  tr.forEach((key, value) {
    if (recentCount == 7) {
      return;
    }

    if (value.isNotEmpty) {
      list.add(
        Card(
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              '$key',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          color: Color.fromARGB(255, 65, 65, 65),
        ),
      );
      recentCount++;
    }

    value.forEach((tr) {
      list.add(
          transactionCard(tr.category, tr.title, tr.amount, tr.amountType));
    });
  });

  return list;
}
