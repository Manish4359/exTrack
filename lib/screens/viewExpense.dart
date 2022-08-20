import 'package:extrack/expenseActions.dart';
import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/expensesProvider.dart';

class ViewExpense extends StatelessWidget {
  Expense ex;
  ViewExpense({Key? key, required this.ex}) : super(key: key);

  Widget buildButton(IconData icon, String text, Color color, fn) {
    return InkWell(
      onTap: fn,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: color),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget builderContainer(IconData icon, String label, String text) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green.withOpacity(0.4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 45,
            width: 45,
            child: Icon(icon),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              '$label',
              //'${DateFormat.yMd().format(expense.date)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              //margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              //height: double,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(10), color: Colors.blue
                  ),
              child: Text(
                '$text',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //   color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesData = Provider.of<ExpensesProvider>(context);

    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          // height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            /* gradient: LinearGradient(
                  colors: [
                Color.fromARGB(255, 225, 254, 162),
                Color.fromARGB(255, 225, 254, 162).withOpacity(0.8)
              ],
                ),*/
          ),
          child: Column(
            children: [
              builderContainer(Icons.currency_rupee, 'Amount', '₹${ex.amount}'),
              builderContainer(Icons.category, 'Category', ex.category),
              builderContainer(Icons.calendar_month, 'Date',
                  DateFormat.yMd().format(ex.date)),
              builderContainer(Icons.history_edu, 'Remarks', ex.title),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildButton(
              Icons.edit,
              'edit',
              Colors.blue,
              () {
                print(ex);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpense(
                      editExpenseData: ex,
                    ),
                  ),
                );
              },
            ),
            buildButton(Icons.delete, 'delete', Colors.red, () {
              expensesData.deleteExpense(ex);
              Navigator.pop(context);
            }),
          ],
        )
      ],
    );
  }
}
