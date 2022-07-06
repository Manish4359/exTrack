import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatelessWidget {
  TextEditingController cardAmount = TextEditingController();
  TextEditingController cardtitle = TextEditingController();

  Function addToList;

  AddExpense(this.addToList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Colors.black,
          ),
      body: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              TextField(
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 136, 136, 136),
                  ),
                  hintText: 'Add an amount',
                  hintStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  prefixIcon: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.currency_rupee_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 60, maxWidth: 60),
                  suffixText: 'INR',
                ),
                controller: cardAmount,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                  labelText: 'Title',
                  labelStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 136, 136, 136),
                  ),
                  hintText: 'Add a title',
                ),
                cursorColor: Colors.black,
                controller: cardtitle,
                keyboardType: TextInputType.name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    Expense newtr = Expense(
                      title: cardtitle.text,
                      amount: int.parse(cardAmount.text),
                      date: DateTime.now(),
                      amountType: 'debit',
                      category: 'others',
                    );
                    await this.addToList(newtr);

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: Text(
                    'Add transaction',
                    style: TextStyle(fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
