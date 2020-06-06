import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/order.dart';
import 'package:puzzle_Store/widgets/product_item.dart';
//import 'package:stripe_payment/stripe_payment.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle_Store/redux/actions.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool _isSubmitting = false;
  @override
  void initState() {
    super.initState();
    // StripePayment.setOptions(StripeOptions(
    //   publishableKey: "pk_test_zglTAFBriYBOP8VrYIVSBFbR00Mf5sFwtL",
    // ));
  }

  @override
  Widget build(BuildContext context) {
    Future _showCheckoutDialog(AppState state) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          if (state.cards.length == 0) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Please add a payment method before proceeding',
                style: GoogleFonts.getFont(
                  'Manrope',
                  textStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              content: FlatButton.icon(
                icon: Icon(Icons.credit_card),
                onPressed: () => Navigator.of(context).pushNamed('/profile'),
                label: Text('add a card'),
              ),
            );
          }
          String _calculateTotalPrice() {
            double totalPrice = 0.0;
            state.cart.forEach((element) {
              totalPrice += element.price;
            });
            return totalPrice.toStringAsFixed(2);
          }

          final customTextStyle = GoogleFonts.getFont(
            'Manrope',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          );
          String cartSumarry = '';
          state.cart.forEach((element) {
            cartSumarry += "·${element.name}, \$${element.price}\n";
          });
          final primaryCard = state.cards
              .singleWhere((card) => card['id'] == state.cardToken)['card'];
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(child: Text('Checkout')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Cart Items : ${state.cart.length}\n',
                    style: customTextStyle,
                  ),
                  Text(
                    '$cartSumarry',
                    style: customTextStyle,
                  ),
                  Text(
                    'Card Details\n',
                    style: customTextStyle,
                  ),
                  Text(
                    'Brand : ${primaryCard['brand']}',
                    style: customTextStyle,
                  ),
                  Text(
                    'Card Number :${primaryCard['last4']}',
                    style: customTextStyle,
                  ),
                  Text(
                    'Expires On : ${primaryCard['exp_month']} / ${primaryCard['exp_year']}\n',
                    style: customTextStyle,
                  ),
                  Text(
                    'Order Total : ${_calculateTotalPrice()}',
                    style: customTextStyle,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'close',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                color: Colors.white,
              ),
              RaisedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.black,
              ),
            ],
          );
        },
      ).then((value) async {
        String _calculateTotalPrice() {
          double totalPrice = 0.0;
          state.cart.forEach((element) {
            totalPrice += element.price;
          });
          return totalPrice.toStringAsFixed(2);
        }

        _showSuccessDialog() {
          return showDialog(
            context: context,
            builder: (BuildContext context) => SimpleDialog(
              title: Text('Success' , style : GoogleFonts.getFont(
            'Manrope',
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 40,
            ),
          )),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Order successful! check your email for a reciept of your purchase\n\nOrder summery will appear in your orders tab',
                    style: GoogleFonts.getFont(
                      'Manrope',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        _checkOutCardProdut() async {
          //create new order in strapi
          http.Response response =
              await http.post('http://10.0.2.2:1337/orders', headers: {
            'Authorization': 'Bearer ${state.user.jwt}'
          }, body: {
            'amount': _calculateTotalPrice(),
            'products': json.encode(state.cart),
            'source': state.cardToken,
            'customer': state.user.stripeId,
          });
          final responseData = json.decode(response.body);
          return responseData;
        }

        if (value == true) {
          //add loading spinner
          setState(() => _isSubmitting = true);
          //check out cart products (create order date in stripe + charge card )
          final newOrderData = await _checkOutCardProdut();
          //creat a new order instance
          Order newOrder = Order.fromJson(newOrderData);
          
          //pass order instance to new action
          StoreProvider.of<AppState>(context)
              .dispatch(AddOrderAction(newOrder));
          //clear cart products
          StoreProvider.of<AppState>(context).dispatch(clearCartAction);
          //hide the loading spinner
          setState(() {
            _isSubmitting = false;
          });
          //show a success dialog
          _showSuccessDialog();
        }
        //
      });
    }

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        String _calculateTotalPrice() {
          double totalPrice = 0.0;
          state.cart.forEach((element) {
            totalPrice += element.price;
          });
          return totalPrice.toStringAsFixed(2);
        }

        return ModalProgressHUD(
          color: Colors.black,
          inAsyncCall: _isSubmitting,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            bottomNavigationBar: state.cart.length == 0
                ? Text('')
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 100 * 15,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Total : ${_calculateTotalPrice()}\$',
                            style: GoogleFonts.getFont(
                              'Manrope',
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          FlatButton(
                            color: Colors.black,
                            onPressed: () {
                              _showCheckoutDialog(state);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: StoreConnector<AppState, AppState>(
                                  converter: (store) => store.state,
                                  builder: (context, state) {
                                    return Text(
                                      'Checkout',
                                      style: GoogleFonts.getFont(
                                        'Manrope',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                      ),
                    ),
                  ),
            body: state.cart.isEmpty
                ? emptyCartContainer()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.cart.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProuctItem(state.cart[index], state);
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Container emptyCartContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Your cart is currently empty!",
            style: GoogleFonts.getFont(
              'Manrope',
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 60,
              ),
            ),
          )
        ],
      ),
    );
  }
}
