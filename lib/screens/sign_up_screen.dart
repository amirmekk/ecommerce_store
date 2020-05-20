import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email, _password, _username;
  bool _obsecureText = true, _isSubmitting = false;
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
        onPressed: () {
          _submit();
        },
        child: _isSubmitting
            ? CircularProgressIndicator(
                backgroundColor: Colors.black,
              )
            : Text(
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
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
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
              onSaved: (value) => _username = value,
              validator: (value) {
                if (value.length < 5) {
                  return 'username is too short';
                } else {
                  return null;
                }
              },
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: sharedTextInputDecoration('Username'),
            ),
            TextFormField(
              onSaved: (value) => _email = value,
              validator: (value) {
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'email is not valid';
                } else {
                  return null;
                }
              },
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: sharedTextInputDecoration('Email'),
            ),
            TextFormField(
              onSaved: (value) => _password = value,
              validator: (value) {
                if (value.length < 6) {
                  return 'password is too short';
                } else {
                  return null;
                }
              },
              style: TextStyle(
                color: Colors.white,
              ),
              obscureText: _obsecureText,
              decoration: InputDecoration(
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
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: greyColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obsecureText = !_obsecureText;
                    });
                  },
                  icon: _obsecureText
                      ? Icon(Icons.visibility, color: greyColor)
                      : Icon(Icons.visibility_off, color: greyColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      registerUser();
      _showSuccessSnack();
    } else {
      print('there is an error in submitting');
    }
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text('$_username is successfuly created'),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void registerUser() async {
    setState(() {
      _isSubmitting = true;
    });
    http.Response response = await http.post(
        'http://10.0.2.2:1337/auth/local/register',
        body: {"email": _email, "password": _password, "username": _username});
    final responseData = json.decode(response.body);
    setState(() {
      _isSubmitting = false;
    });
    print(responseData);
    _redirectUser();
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.popAndPushNamed(context, '/products');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
