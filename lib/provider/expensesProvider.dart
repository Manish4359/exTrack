import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

//final uid = auth.currentUser?.uid;
final CollectionReference = db.collection('users');

class ExpensesProvider with ChangeNotifier {
  final userName = auth.currentUser?.displayName;
  final usermail = auth.currentUser?.email;

  fn(Expense ex) async {
    // Create a new user with a first and last name

    /*
    final user = <String, dynamic>{
      "mail": usermail,
      "last": "Lovelace",
      "born": [Random().nextInt(100)]
    };
    */
    final userName = auth.currentUser?.displayName;
    final usermail = auth.currentUser?.email;
    final uid = auth.currentUser?.uid;
    final CollectionReference = db.collection('users');

    var map = objToMap(ex);
    print(map);
    print(mapToJson(map));

    var date = DateFormat.yMd().format(ex.date);
    date = date.replaceAll(RegExp('/'), '-');

// Add a new document with a generated ID
    CollectionReference.doc(uid).collection(date).add(map);
  }

  Map<String, List<Expense>> _expenses = {};

  objToMap(Expense ex) {
    return {
      'id': ex.id,
      'amount': ex.amount,
      'date': DateFormat.yMd().format(ex.date),
      'title': ex.title,
      'amountType': ex.amountType,
      'category': ex.category,
    };
  }

  mapToObj(Map<String, dynamic> ex) {
    Expense expense = Expense(
        amount: ex['amount'],
        date: DateFormat.yMd().parse(ex['date']),
        title: ex['title'],
        category: ex['category'],
        amountType: ex['amountType']);

    expense.setId(ex['id']);

    return expense;
  }

  mapToJson(map) {
    return jsonEncode(map);
  }

  loadAllExpenses() async {
    final uid = auth.currentUser?.uid;
    final userData = await CollectionReference.doc(uid)
        .get()
        .then((snapshot) => snapshot.data());

    _expenses = {};
    userData?.forEach((date, list) {
      List<Expense> exList = [];
      list.forEach((element) => exList.add(mapToObj(element)));
      _expenses.addEntries([MapEntry(date, exList)]);
    });
  }

  getAllExpense() {
    loadAllExpenses();
    return {..._expenses};
  }

  addExpense(ex) async {
    final uid = auth.currentUser?.uid;
    String exDate = DateFormat.yMd().format(ex.date);
    var map = objToMap(ex);
    print(map);
    print(mapToJson(map));

    final data = await CollectionReference.doc(uid)
        .get()
        .then((value) => value.data()?[exDate]);

    if (data == null) {
      await CollectionReference.doc(uid).set({
        exDate: [map]
      });
    } else {
      await CollectionReference.doc(uid).set({
        exDate: [map, ...data]
      });
    }
    await loadAllExpenses();
    print("added");

    /*
    if (_expenses.containsKey(exDate)) {
      _expenses[exDate]?.insert(0, ex);
    } else {
      _expenses.addEntries([
        MapEntry(exDate, [ex])
      ]);
    } */

    notifyListeners();
  }

  editExpense(Map<String, dynamic> ex) {
    String date = DateFormat.yMd().format(ex['date']);

    // CollectionReference.doc(uid).collection(exDate).doc(ex.id).

    if (_expenses.containsKey(date)) {
      _expenses[date]!.forEach(
        (expense) {
          print('saving ${ex['id']} ${expense.id}');
          if (expense.id == ex['id']) {
            print('saved');

            expense.title = ex['title'];
            expense.amount = ex['amount'];
            expense.category = ex['category'];
          }
        },
      );
    }
    notifyListeners();
  }

  deleteExpense(Expense ex) async {
    final uid = auth.currentUser?.uid;
    String date = DateFormat.yMd().format(ex.date);
    print(date + " " + '${_expenses.containsKey(date)}');

    print('${ex.id} ${ex.title}');

    CollectionReference.doc(uid).collection(date);
    /*
    _expenses[date]!.remove(ex);

    if (_expenses[date]!.isEmpty) {
      _expenses.remove(date);
    }
    */
    notifyListeners();
  }

  double getTotalExpenseAmount() {
    double amount = 0;

    for (MapEntry e in _expenses.entries) {
      amount += getMonthlyExpenseAmount(e.key);
    }

    return amount;
  }

  double getMonthlyExpenseAmount(String date) {
    double amount = 0;
    _expenses[date]!.forEach((t) {
      amount += t.amount;
    });

    return amount;
  }
}
