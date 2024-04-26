import 'package:extrack/provider/expensesProvider.dart';
import 'package:extrack/screens/signinAndSignup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:extrack/models/expense.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';

class Profile extends StatefulWidget {
  VoidCallback userSigned;
  Profile({Key? key, required this.userSigned}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpensesProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: expenseProvider.guestLogin
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'SignIn to save your data',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'sign in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignIn.routeName);
                    },
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.hardEdge,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.amber,
                    ),
                    child: Image.asset('assets/images/user.jpg'),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 2, color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      //tileColor: Colors.orange,
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        'userName',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 2, color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: ListTile(
                      //tileColor: Colors.orange,
                      leading: Icon(Icons.account_circle),
                      title: Text(
                        '${expenseProvider.usermail}',
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 2, color: Color.fromARGB(255, 46, 46, 46)),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: const ListTile(
                      //tileColor: Colors.orange,
                      leading: Icon(Icons.account_circle),
                      title: Text(
                        'phone',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'signout',
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      widget.userSigned();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 220);
    path.quadraticBezierTo(size.width / 4, 160 /*180*/, size.width / 2, 175);
    path.quadraticBezierTo(3 / 4 * size.width, 190, size.width, 130);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
