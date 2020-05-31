import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/redux/actions.dart';

class ProductDetailPage extends StatefulWidget {
  final Product item;
  ProductDetailPage({this.item});
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isInCart(AppState state, String id) {
    final List<Product> existingCartProducts = state.cart;
    final indexOfProduct =
        existingCartProducts.indexWhere((element) => id == element.id);
    final isInCart = indexOfProduct > -1 == true;
    if (isInCart) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: widget.item,
            child: Image.network(
              'http://10.0.2.2:1337${widget.item.picture[0]['url']}',
              height: MediaQuery.of(context).size.height / 100 * 40,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Text(
              '${widget.item.name}',
              style: GoogleFonts.getFont(
                'Manrope',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  '${widget.item.description}',
                  style: GoogleFonts.getFont(
                    'Manrope',
                    textStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_basket,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 100 * 15,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '\$',
                      style: GoogleFonts.getFont(
                        'Manrope',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: '${widget.item.price}',
                      style: GoogleFonts.getFont(
                        'Manrope',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              FlatButton(
                color: Colors.black,
                onPressed: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(toggleProductInCartAction(widget.item));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: StoreConnector<AppState, AppState>(
                      converter: (store) => store.state,
                      builder: (context, state) {
                        return Text(
                          _isInCart(state, widget.item.id)
                              ? 'Remove from cart'
                              : 'Add to cart',
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
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
