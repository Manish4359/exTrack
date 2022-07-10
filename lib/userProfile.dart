import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:extrack/models/expense.dart';

import './models/expense.dart';

class Profile extends StatefulWidget {
  VoidCallback userSigned;
  Profile({Key? key, required this.userSigned}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: ElevatedButton(
          child: Text('signout'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            widget.userSigned();
          },
        ),
      )),
    );
  }
}
