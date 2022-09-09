import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

//final uid = auth.currentUser?.uid;
final CollectionReference = db.collection('users');

class ExpensesProvider with ChangeNotifier {
  final userName = auth.currentUser?.displayName;
  final usermail = auth.currentUser?.email;
  var userData;

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
    userData = await CollectionReference.doc(uid)
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

    if (userData == null) {
      await CollectionReference.doc(uid).set({
        exDate: [map]
      });
    } else {
      if (userData.containsKey(exDate)) {
        userData[exDate] = [map, ...userData[exDate]];
      } else {
        userData.addEntries([
          MapEntry(exDate, [map])
        ]);
      }
      await CollectionReference.doc(uid).set(userData, SetOptions(merge: true));
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

  editExpense(Map<String, dynamic> ex) async {
    String date = DateFormat.yMd().format(ex['date']);

    final uid = auth.currentUser?.uid;

    userData[date].forEach((data) {
      print("${data['id']} ${ex['id']}");

      if (data['id'] == ex['id']) {
        data['title'] = ex['title'];
        data['amount'] = ex['amount'];
        data['category'] = ex['category'];
      }
    });

    await CollectionReference.doc(uid).set(userData);

    await loadAllExpenses();

    notifyListeners();
  }

  deleteExpense(Expense ex) async {
    final uid = auth.currentUser?.uid;
    String date = DateFormat.yMd().format(ex.date);
    //print(date + " " + '${_expenses.containsKey(date)}');

    print('${ex.id} ${ex.title}');

    userData[date].removeWhere((data) => data['id'] == ex.id);

    await CollectionReference.doc(uid).set(userData);
    await loadAllExpenses();

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
