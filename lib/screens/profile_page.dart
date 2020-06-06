import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/redux/actions.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ProfilePage extends StatefulWidget {
  final void Function() onInit;
  ProfilePage({this.onInit});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    widget.onInit();
    StripePayment.setOptions(StripeOptions(
      publishableKey: "pk_test_zglTAFBriYBOP8VrYIVSBFbR00Mf5sFwtL",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
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
    _addCard(cardToken) async {
      await http.put('http://10.0.2.2:1337/users/${state.user.id}',
          body: {"card_token": cardToken},
          headers: {"Authorization": "Bearer ${state.user.jwt}"});

      http.Response response =
          await http.post('http://10.0.2.2:1337/card/add', body: {
        "source": cardToken,
        "customer": state.user.stripeId,
      });
      final responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    }

    return Container(
      child: Column(
        children: <Widget>[
          userDataWidget(state),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          ListTile(
            trailing: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  final PaymentMethod cardToken =
                      await StripePayment.paymentRequestWithCardForm(
                    CardFormPaymentRequest(),
                  ).catchError((e) => print(e));
                  final card = await _addCard(cardToken.id);
                  //print(card);

                  //1- dispatch an action to store the card in the state with the other cards.
                  StoreProvider.of<AppState>(context)
                      .dispatch(AddCardAction(card));
                  //2- update card token (the one on the server means it is the primary one)
                  StoreProvider.of<AppState>(context)
                      .dispatch(UpdateCardTokenAction(card['id']));
                  //3- show snack bar of success !
                  final Widget snackBar = SnackBar(
                    content: Text(
                      'card added successfuly',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }),
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
          state.cards.length == 0
              ? noCreditCardsWidget()
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      return creditCardContainer(state, index);
                    },
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
          state.orders.length == 0
              ? noRecieptsWidget()
              : Expanded(
                  //height: 100,
                  child: ListView.builder(
                    //padding: EdgeInsets.all(10),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.monetization_on),
                        title: Text(
                          '${state.orders[index].amount}',
                          style: GoogleFonts.getFont(
                            'Manrope',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          '${state.orders[index].createdAt}',
                          style: GoogleFonts.getFont(
                            'Manrope',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          logOutButton(context),
        ],
      ),
    );
  }

  ListTile logOutButton(BuildContext context) {
    return ListTile(
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
    );
  }

  Padding userDataWidget(AppState state) {
    return Padding(
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
    );
  }

  Text noCreditCardsWidget() {
    return Text(
      'you have no credit cards',
      style: GoogleFonts.getFont(
        'Manrope',
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Text noRecieptsWidget() {
    return Text(
      'When you buy something your reciepts will appear here.',
      style: GoogleFonts.getFont(
        'Manrope',
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Container creditCardContainer(AppState state, int index) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(45, 20, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            '**** **** **** ${state.cards[index]['card']['last4']} ',
            style: GoogleFonts.getFont(
              'Manrope',
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Text(
                      '${state.cards[index]['card']['brand']}',
                      style: GoogleFonts.getFont(
                        'Manrope',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${state.cards[index]['card']['exp_month']}  / ${state.cards[index]['card']['exp_year']}',
                    style: GoogleFonts.getFont(
                      'Manrope',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              FlatButton.icon(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      UpdateCardTokenAction(state.cards[index]['id']));
                },
                icon: state.cards[index]['id'] == state.cardToken
                    ? Icon(Icons.star)
                    : Icon(Icons.star_border),
                label: state.cards[index]['id'] == state.cardToken
                    ? Text('primary card')
                    : Text('set as primary'),
              )
            ],
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
