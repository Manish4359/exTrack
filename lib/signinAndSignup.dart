import 'package:extrack/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
/*
class SignInAndSignUp extends StatefulWidget {
  SignInAndSignUp({Key? key}) : super(key: key);

  @override
  State<SignInAndSignUp> createState() => _SignInAndSignUpState();
}

class _SignInAndSignUpState extends State<SignInAndSignUp> {
  //bool showSignupPage = false;
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
*/

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 220);
    path.quadraticBezierTo(size.width / 4, 160 /*180*/, size.width / 2, 175);
    path.quadraticBezierTo(3 / 4 * size.width, 190, size.width, 130);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  IconData icon;
  bool obscureText;
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.icon,
      this.obscureText = false})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPass = true;
  bool showText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 237, 237, 237),
            offset: Offset(0, 2),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        obscureText: widget.obscureText ? showText : false,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide.none),
          hintText: widget.hintText,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  child:
                      Icon(showPass ? Icons.visibility : Icons.visibility_off),
                  onTap: () => setState(() {
                    showPass = !showPass;
                    showText = !showText;
                  }),
                )
              : null,
          //  suffixIcon: Icon(Icons.lock),
          hintStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          //  hintText: 'Add a title',
        ),
        cursorColor: Colors.black,
        controller: widget.controller,
        keyboardType: TextInputType.name,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  VoidCallback userSigned;
  SignUp({Key? key, required this.userSigned}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passConfirm = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
    passConfirm.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      //backgroundColor: Colors.yellow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text('Create account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                icon: Icons.person,
                hintText: 'Name',
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                icon: Icons.mail,
                hintText: 'Email',
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: passController,
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                  controller: passConfirm,
                  icon: Icons.lock,
                  hintText: 'Confirm Password',
                  obscureText: true),
              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Row(
                        children: [
                          Text(
                            'SignUp',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.arrow_forward,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          if (passConfirm.text != passController.text) {
                            new Exception('confirm password is not matching');
                          }

                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text,
                          );
                          print(credential.user);
                          widget.userSigned();
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                          print('errrr');
                        }
                      },
                    )
                  ],
                ),
              ),
              // Text('Don\'t have an account ? Create')
            ],
          ),
        ),
      ),
    );
  }
}

class SignIn extends StatefulWidget {
  VoidCallback userSigned;
  SignIn({Key? key, required this.userSigned}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  clearControllers() {
    setState(() {
      emailController.clear();
      passController.clear();
    });
  }

  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.yellow,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'sign in to your account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60),
              CustomTextField(
                controller: emailController,
                icon: Icons.mail,
                hintText: 'Email',
              ),
              SizedBox(height: 20),
              CustomTextField(
                  controller: passController,
                  icon: Icons.lock,
                  hintText: 'Password',
                  obscureText: true),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot your password?',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black),
                      child: Row(
                        children: [
                          Text(
                            'Sign in',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.arrow_forward,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text,
                          );

                          print(credential.user);

                          if (credential.user != null) {
                            widget.userSigned();
                          }
                        } catch (e) {
                          print(e);
                          print('no user found');
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: Container(
                      child: Text(
                        'Create',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {
                      clearControllers();
                      Navigator.pushNamed(context, '/signup');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
