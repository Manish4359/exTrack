import 'package:extrack/constant.dart';
import 'package:extrack/widgets/customTextField.dart';
import 'package:extrack/provider/expensesProvider.dart';
import 'package:extrack/screens/userProfile.dart';
import 'package:extrack/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddExpense extends StatefulWidget {
  Expense? editExpenseData;

  AddExpense({Key? key, this.editExpenseData}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController cardAmount = TextEditingController();
  TextEditingController cardtitle = TextEditingController();

  int selectedCatId = 0;
  String amountType = 'debit';
  bool editExpense = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.editExpenseData != null) {
      editExpense = true;
      cardtitle.text = widget.editExpenseData!.title;
      cardAmount.text = (widget.editExpenseData!.amount).toString();
      amountType = widget.editExpenseData!.amountType;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.editExpenseData);
    final expensesData = Provider.of<ExpensesProvider>(context);
    List<String> categorylist = Constants.CATEGORIES;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
                  value: editExpense
                      ? categorylist.firstWhere((element) =>
                          element == widget.editExpenseData!.category)
                      : categorylist[selectedCatId],

                  dropdownColor: Color.fromARGB(255, 245, 247, 255),
                  borderRadius: BorderRadius.circular(10),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  // menuMaxHeight: 40,
                  items: categorylist
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
                            categorylist.indexOf(newCategory as String);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (editExpense) {
                    Map<String, dynamic> editData = {
                      'id': widget.editExpenseData!.id,
                      'amount': int.parse(cardAmount.text),
                      'date': widget.editExpenseData!.date,
                      'title': cardtitle.text,
                      'category': categorylist[selectedCatId]
                    };

                    await expensesData.editExpense(editData);
                  } else {
                    Expense newtr = Expense(
                      title: cardtitle.text,
                      amount: int.parse(cardAmount.text),
                      date: DateTime.now(),
                      amountType: 'debit',
                      category: categorylist[selectedCatId],
                    );
                    await expensesData.addExpense(newtr);
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
                  editExpense ? 'Save Expense' : 'Add Expense',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
