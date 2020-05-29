import 'package:flutter/material.dart';
import 'package:puzzle_Store/models/product.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle_Store/screens/product_detail_page.dart';

class ProuctItem extends StatelessWidget {
  final Product _itemData;
  final String baseUrl = 'http://10.0.2.2:1337';
  ProuctItem(this._itemData);
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Hero(
                  tag: _itemData,
                  child: Image.network(
                    '$baseUrl${_itemData.picture[0]['url']}',
                    width: 150,
                    height: 150,
                  ),
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
            ],
          )),
    );
  }
}
