import 'package:flutter/material.dart';
import '../models/expense.dart';

import './../screens/viewExpense.dart';

class ExpenseCard extends StatelessWidget {
  Expense expense;

  ExpenseCard({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
          //barrierColor: Color.fromARGB(255, 0, 0, 0).withAlpha(50),
          context: context,
          builder: (context) => ViewExpense(
                ex: expense,
              )),
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 228, 252, 231),
          //borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 226, 226, 226),
                offset: Offset(0, 2),
                spreadRadius: 1),
          ],
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
                      expense.category,
                      //'${DateFormat.yMd().format(expense.date)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      expense.title,
                      style: const TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                //height: double,
                decoration: const BoxDecoration(
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
                        : Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
