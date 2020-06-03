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

ThunkAction<AppState> logUserOutAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;

  store.dispatch(LogUserOutAction(user));
};

class LogUserOutAction {
  final User _user;
  User get user => this._user;
  LogUserOutAction(this._user);
}

// product action list
ThunkAction<AppState> getProductAction = (Store<AppState> store) async {
  http.Response response = await http.get(
    'http://10.0.2.2:1337/products',
  );
  final List responseData = json.decode(response.body);
  List<Product> products = [];
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

//cart action
ThunkAction<AppState> toggleProductInCartAction(Product product) {
  return (Store<AppState> store) async {
    final List<Product> existingCartProducts = store.state.cart;
    final indexOfProduct =
        existingCartProducts.indexWhere((element) => product.id == element.id);
    List<Product> updatedCartProducts = List.from(existingCartProducts);
    final isInCart = indexOfProduct > -1 == true;
    if (isInCart) {
      updatedCartProducts.removeAt(indexOfProduct);
    } else {
      updatedCartProducts.add(product);
    }
    final List<String> cartProductsIds = updatedCartProducts.map((element) {
      return element.id;
    }).toList();
    await http.put('http://10.0.2.2:1337/carts/${store.state.user.cartId}',
        headers: {"Authorization": 'Bearer ${store.state.user.jwt}'},
        body: {'products': json.encode(cartProductsIds)});
    store.dispatch(ToggleProductInCartAction(updatedCartProducts));
  };
}

class ToggleProductInCartAction {
  final List<Product> _products;
  List<Product> get products => this._products;
  ToggleProductInCartAction(this._products);
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }
  final User user = User.fromJson(json.decode(storedUser));
  List<Product> cartProducts = [];
  http.Response response = await http.get(
      'http://10.0.2.2:1337/carts/${user.cartId}',
      headers: {'Authorization': 'Bearer ${user.jwt}'});
  final responseData = json.decode(response.body)['products'];
  responseData.forEach((item) {
    final Product product = Product.fromJson(item);
    cartProducts.add(product);
  });
  print('my response data is : $responseData');
  store.dispatch(GetCartProductAction(cartProducts));
};

class GetCartProductAction {
  final List<Product> _products;
  List<Product> get products => _products;
  GetCartProductAction(this._products);
}

//card actions
ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String stripeId = store.state.user.stripeId;
  http.Response response =
      await http.get('http://10.0.2.2:1337/card?$stripeId');
  final responseData = json.decode(response.body);
  print('my response data for profile page is : $responseData');
  store.dispatch(GetCardsAction(responseData));
};

class GetCardsAction {
  final List<dynamic> _cards;
  List<dynamic> get cards => _cards;
  GetCardsAction(this._cards);
}

class AddCardAction {
  final dynamic _card;
  dynamic get card => _card;
  AddCardAction(this._card);
}

// card token action
class UpdateCardTokenAction {
  final String _cardToken;
  String get cardToken => _cardToken;
  UpdateCardTokenAction(this._cardToken);
}

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  http.Response response = await http.get('http://10.0.2.2:1337/users/me',
      headers: {'Authorization': 'Bearer $jwt'});
  final responseData = json.decode(response.body);
  store.dispatch(GetCardTokenAction(responseData['card_token']));
};

class GetCardTokenAction {
  final String _cardToken;
  String get cardToken => _cardToken;
  GetCardTokenAction(this._cardToken);
}
