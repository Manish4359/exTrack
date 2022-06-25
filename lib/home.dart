import 'package:flutter/material.dart';

import './models/transaction.dart';

class Home extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;
  Home({Key? key, required this.transactions}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.green, Colors.orange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Text('home'),
    );
  }
}
