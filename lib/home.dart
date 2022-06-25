import 'package:flutter/material.dart';

import './models/transaction.dart';

class Home extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;
  Function viewTransactions;
  Home({Key? key, required this.transactions, required this.viewTransactions})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          margin: EdgeInsets.all(40),
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              'data',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(50)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('recent expenses'),
            ElevatedButton(
                onPressed: () {
                  widget.viewTransactions(3);
                },
                child: Text('view all'))
          ],
        ),
        Expanded(child: ListView(children: recentTr(widget.transactions))),
      ],
    );
  }
}

Card transactionCard() {
  return Card(
    clipBehavior: Clip.hardEdge,
    color: Color.fromARGB(255, 247, 247, 247),
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
    ),
    child: Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            //height: double,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.blue),
            child: Text(
              '₹456',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'title',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text('date')
              ],
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
      list.add(Card(child: Text('$key')));
      recentCount++;
    }

    value.forEach((element) {
      list.add(transactionCard());
    });
  });

  return list;
}
