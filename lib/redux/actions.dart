import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/product.dart';
import 'package:puzzle_Store/models/user.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

// user actions section

ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final storedUser = prefs.getString('user');
  final user =
      storedUser == null ? null : User.fromJson(json.decode(storedUser));
  store.dispatch(GetUserAction(user));
};

class GetUserAction {
  final User _user;
  User get user => this._user;
  GetUserAction(this._user);
}

// product action list
ThunkAction<AppState> getProductAction = (Store<AppState> store) async {
  http.Response response = await http.get(
    'http://10.0.2.2:1337/products',
  );
  final List responseData = json.decode(response.body);
  List<Product> products=[];
  responseData.forEach((element) {
    final Product product = Product.fromJson(element);
    products.add(product);
  });
  store.dispatch(GetProductAction(products));
};

class GetProductAction {
  final List<Product> _products;
  List<Product> get products => this._products;
  GetProductAction(this._products);
}
