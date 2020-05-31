import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/screens/product_detail_page.dart';
import 'package:puzzle_Store/redux/actions.dart';

class ProuctItem extends StatelessWidget {
  final AppState state;
  final Product _itemData;
  final String baseUrl = 'http://10.0.2.2:1337';
  ProuctItem(this._itemData, this.state);
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
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductDetailPage(item: _itemData);
        }));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Hero(
              tag: _itemData,
              child: Image.network(
                '$baseUrl${_itemData.picture[0]['url']}',
                width: 150,
                height: 150,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    '${_itemData.name}',
                    style: GoogleFonts.getFont(
                      'Manrope',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Text(
                  '\$${_itemData.price}',
                  style: GoogleFonts.getFont(
                    'Manrope',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            state.user == null
                ? Text('')
                : IconButton(
                    icon: Icon(
                      _isInCart(state, _itemData.id)
                          ? Icons.remove_shopping_cart
                          : Icons.add_shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      StoreProvider.of<AppState>(context)
                          .dispatch(toggleProductInCartAction(_itemData));
                    }),
          ],
        ),
      ),
    );
  }
}
