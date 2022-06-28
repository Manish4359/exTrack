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
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 234, 234, 234),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [],
          ),
        ),
        Image.asset(
          'assets/images/wine.png',
          scale: 2,
        ),
      ],
    );
  }
}
