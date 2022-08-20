import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/expensesProvider.dart';
import '../widgets/expenseCard.dart';
import '../models/expense.dart';

class UserAllExpenses extends StatefulWidget {
  UserAllExpenses({
    Key? key,
  }) : super(key: key);

  @override
  State<UserAllExpenses> createState() => _UserAllExpensesState();
}

class _UserAllExpensesState extends State<UserAllExpenses> {
  // String selectedDate = DateFormat.yMd().format(DateTime.now());
  String selectedDate = DateFormat.yMd().format(DateTime.now());
  Future<void> datePicker() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat.yMd().parse(selectedDate),
        firstDate: DateFormat.yMd().parse('1/1/2020'),
        lastDate: DateFormat.yMd().parse('31/12/2100'));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateFormat.yMd().format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesData = Provider.of<ExpensesProvider>(context);
    final Map<String, List<Expense>> expenses = expensesData.getAllExpense();
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 58, 58, 58),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '${DateFormat.EEEE().format(DateFormat.yMd().parse(selectedDate))},${DateFormat.yMMMMd().format(DateFormat.yMd().parse(selectedDate))}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        datePicker();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 113, 189, 255),
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                //   width: 300,
                //   height: 300,
                child: ListView(
                  children: monthlyExpense(
                    expenses,
                    selectedDate,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> monthlyExpense(
  Map<String, List<Expense>> ex,
  String selectedDate,
) {
  List<Widget> list = [];

  if (ex.containsKey(selectedDate)) {
    ex[selectedDate]!.forEach((expense) {
      list.add(ExpenseCard(
        expense: expense,
      ));
    });
  } else {
    list.add(Text('No Data Found!!'));
  }

  return list;
}
