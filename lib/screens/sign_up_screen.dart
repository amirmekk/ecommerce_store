import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final greyColor = Color(0xff7e7f81);
  InputDecoration sharedTextInputDecoration(String title) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      labelText: title,
      labelStyle: TextStyle(
        color: greyColor,
      ),
    );
  }

  Widget mrPuzzleTitleWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 130.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'mr.', style: Theme.of(context).textTheme.headline2),
                TextSpan(
                    text: 'PUZZLES',
                    style: Theme.of(context).textTheme.headline1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(40, 30, 0, 10),
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      child: FlatButton(
        onPressed: () {},
        child: Text(
          'Sign Up',
        ),
        color: Colors.white,
      ),
    );
  }

  Widget logInButton() {
    return Container(
      padding: EdgeInsets.only(left: 40.0),
      child: FlatButton(
        onPressed: () {},
        child: Text(
          'Already a user? log in',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget logInForm() {
    return Padding(
      padding: EdgeInsets.only(left: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: sharedTextInputDecoration('Username'),
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: sharedTextInputDecoration('Email'),
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              obscureText: true,
              decoration: sharedTextInputDecoration('Password'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: <Widget>[
            mrPuzzleTitleWidget(),
            logInForm(),
            signUpButton(),
            logInButton(),
          ],
        )),
      ),
    );
  }
}
