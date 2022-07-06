import 'package:extrack/category.dart';
import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  Function addToList;
  List<String> categorylist;

  AddExpense({Key? key, required this.addToList, required this.categorylist})
      : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController cardAmount = TextEditingController();
  TextEditingController cardtitle = TextEditingController();

  int selectedCatId = 0;

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
                  //suffixText: 'INR',
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
              Container(
                height: 70,
                width: 200,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                // width: 200,
                child: DropdownButtonFormField(
                  isExpanded: true,
                  isDense: false,
                  value: widget.categorylist[selectedCatId],

                  dropdownColor: Color.fromARGB(255, 245, 247, 255),
                  borderRadius: BorderRadius.circular(10),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  // menuMaxHeight: 40,
                  items: widget.categorylist
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Container(
                            // height: 0,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/$category.png',
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  category,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newCategory) {
                    setState(() {
                      selectedCatId =
                          widget.categorylist.indexOf(newCategory as String);
                    });
                  },
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  Expense newtr = Expense(
                    title: cardtitle.text,
                    amount: int.parse(cardAmount.text),
                    date: DateTime.now(),
                    amountType: 'debit',
                    category: widget.categorylist[selectedCatId],
                  );
                  await widget.addToList(newtr);

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
                  'Add Expense',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
