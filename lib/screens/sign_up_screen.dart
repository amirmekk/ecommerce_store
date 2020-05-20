import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _username;
  bool _obsecureText = true;
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

  _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      print('$_username , $_email , $_password');
    } else {
      print('there is an error in submitting');
    }
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