import 'package:extrack/customTextField.dart';
import 'package:extrack/models/expensesData.dart';
import 'package:extrack/userProfile.dart';
import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  Function addToList;
  List<String> categorylist;
  bool editExpense;
  Expense? editExpenseData;
  Function deleteExpense;
  Function saveExpense;

  AddExpense({
    Key? key,
    required this.addToList,
    required this.categorylist,
    required this.deleteExpense,
    required this.saveExpense,
    this.editExpense = false,
    this.editExpenseData,
  }) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController cardAmount = TextEditingController();
  TextEditingController cardtitle = TextEditingController();

  int selectedCatId = 0;
  String amountType = 'debit';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editExpense) {
      cardtitle.text = widget.editExpenseData!.title;
      cardAmount.text = (widget.editExpenseData!.amount).toString();
      amountType = widget.editExpenseData!.amountType;
    }
  }

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
              CustomTextField(
                controller: cardAmount,
                hintText: 'Add an amount',
                icon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 50,
              ),
              CustomTextField(
                controller: cardtitle,
                hintText: 'Add a title',
                icon: Icons.edit_note,
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
                  value: widget.editExpense
                      ? widget.categorylist.firstWhere((element) =>
                          element == widget.editExpenseData!.category)
                      : widget.categorylist[selectedCatId],

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
                    setState(
                      () {
                        selectedCatId =
                            widget.categorylist.indexOf(newCategory as String);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!widget.editExpense) {
                        Expense newtr = Expense(
                          title: cardtitle.text,
                          amount: int.parse(cardAmount.text),
                          date: DateTime.now(),
                          amountType: 'debit',
                          category: widget.categorylist[selectedCatId],
                        );
                        await widget.addToList(newtr);
                      } else {
                        Map<String, dynamic> editData = {
                          'title': cardtitle.text,
                          'amount': int.parse(cardAmount.text),
                          'category': widget.categorylist[selectedCatId]
                        };
                        await widget.saveExpense(
                            editData,
                            widget.editExpenseData!.date,
                            widget.editExpenseData!.id);
                      }

                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 65, 65, 65)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      widget.editExpense ? 'Save Expense' : 'Add Expense',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  widget.editExpense
                      ? ElevatedButton(
                          onPressed: () async {
                            await widget.deleteExpense(widget.editExpenseData);
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      : SizedBox()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
