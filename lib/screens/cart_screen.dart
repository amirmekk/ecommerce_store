import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/widgets/product_item.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    // StripePayment.setOptions(StripeOptions(
    //   publishableKey: "pk_test_zglTAFBriYBOP8VrYIVSBFbR00Mf5sFwtL",
    // ));
  }

  @override
  Widget build(BuildContext context) {
    void _checkout() async {
      // dynamic token = await StripePayment.paymentRequestWithCardForm(
      //     CardFormPaymentRequest());
      //print(token);
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
          body: state.cart.isEmpty
              ? Container(
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
                )
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Total : ${_calculateTotalPrice()}\$',
                          style: GoogleFonts.getFont(
                            'Manrope',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        FlatButton(
                            color: Colors.white,
                            onPressed: () {
                              _checkout();
                            },
                            child: Text(
                              'checkout',
                              style: GoogleFonts.getFont(
                                'Manrope',
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 40,
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
        );
      },
    );
  }
}
