import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  String hintText;
  IconData icon;
  bool obscureText;
  TextInputType keyboardType;
  CustomTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.icon,
      this.obscureText = false,
      this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPass = true;
  bool showText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(10),
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
        keyboardType: widget.keyboardType,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
