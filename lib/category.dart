import 'package:flutter/material.dart';

import './models/transaction.dart';

class Category extends StatefulWidget {
  final Map<String, List<Transaction>> transactions;
  const Category({Key? key, required this.transactions}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('category'),
    );
  }
}
