import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/redux/actions.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: state.user == null
                ? noUserContainer(context)
                : userExistsContainer(context, state),
          );
        });
  }

  Container userExistsContainer(BuildContext context, AppState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.person_pin,
                    size: 60,
                    color: Colors.black,
                  ),
                  radius: 40,
                  backgroundColor: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Username : ${state.user.username}',
                      style: GoogleFonts.getFont(
                        'Manrope',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      'Email : ${state.user.email}',
                      style: GoogleFonts.getFont(
                        'Manrope',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.credit_card, color: Colors.white),
            title: Text(
              'credit cards',
              style: GoogleFonts.getFont(
                'Manrope',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.receipt, color: Colors.white),
            title: Text(
              'Reciepts',
              style: GoogleFonts.getFont(
                'Manrope',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            onTap: () {
              StoreProvider.of<AppState>(context).dispatch(logUserOutAction);
            },
            title: Text(
              'Logout',
              style: GoogleFonts.getFont(
                'Manrope',
                textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container noUserContainer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Please Login Or Register First',
            style: GoogleFonts.getFont(
              'Manrope',
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 60,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Text(
                    'Login',
                    style: GoogleFonts.getFont(
                      'Manrope',
                      textStyle: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  color: Colors.white,
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  'register',
                  style: GoogleFonts.getFont(
                    'Manrope',
                    textStyle: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
