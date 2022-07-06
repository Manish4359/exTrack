import 'package:flutter/material.dart';

import 'models/expense.dart';

class UserAllExpenses extends StatefulWidget {
  final Map<String, List<Expense>> expenses;
  UserAllExpenses({Key? key, required this.expenses}) : super(key: key);

  @override
  State<UserAllExpenses> createState() => _UserAllExpensesState();
}

class _UserAllExpensesState extends State<UserAllExpenses> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('UserTransactions',
          style: TextStyle(color: Color.fromARGB(255, 197, 47, 47))),
    );
  }
}
