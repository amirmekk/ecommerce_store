import 'package:flutter/cupertino.dart';
import 'package:puzzle_Store/models/product.dart';

@immutable
class AppState {
  final dynamic user;
  final List<Product> products;
  AppState({@required this.user, @required this.products});
  factory AppState.initial() {
    return AppState(
      user: null,
      products: [],
    );
  }
}
