import 'package:flutter/cupertino.dart';
import 'package:puzzle_Store/models/product.dart';

@immutable
class AppState {
  final dynamic user;
  final List<Product> products;
  final List<Product> cart;
  final List<dynamic> cards;
  final String cardToken;

  AppState(
      {@required this.user,
      @required this.products,
      @required this.cart,
      @required this.cardToken,
      @required this.cards});
  factory AppState.initial() {
    return AppState(
      user: null,
      products: [],
      cart: [],
      cards: [],
      cardToken: '',
    );
  }
}
