import 'package:flutter/material.dart';

import './models/transaction.dart';

class UserTransactions extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;
  UserTransactions({Key? key, required this.transactions}) : super(key: key);

  @override
  State<UserTransactions> createState() => _UserTransactionsState();
}

class _UserTransactionsState extends State<UserTransactions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('UserTransactions',
          style: TextStyle(color: Color.fromARGB(255, 197, 47, 47))),
    );
  }
}
