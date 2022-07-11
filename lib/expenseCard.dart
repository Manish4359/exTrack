import 'package:flutter/material.dart';
import './models/expense.dart';

import 'expenseActions.dart';
import './constant.dart';

class ExpenseCard extends StatelessWidget {
  Expense expense;
  Function deleteExpense;
  ExpenseCard({Key? key, required this.expense, required this.deleteExpense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddExpense(
            addToList: () {},
            categorylist: Constants.CATEGORIES,
            editExpenseData: expense,
            editExpense: true,
            deleteExpense: deleteExpense,
          ),
        ),
      ),
      child: Card(
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
                      '${expense.category}',
                      //'${DateFormat.yMd().format(expense.date)}',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
