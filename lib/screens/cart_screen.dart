import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/widgets/product_item.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
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
              : ListView.builder(
                  itemCount: state.cart.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProuctItem(state.cart[index], state);
                  },
                ),
        );
      },
    );
  }
}
