import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/product.dart';
import 'package:puzzle_Store/models/user.dart';
import 'package:puzzle_Store/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    user: userReducer(state.user, action),
    products: productsReducer(state.products, action),
    cart: cartReducer(state.cart, action),
  );
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  }
  if (action is LogUserOutAction) {
    return action.user;
  }
  return user;
}

List<Product> productsReducer(List<Product> product, dynamic action) {
  if (action is GetProductAction) {
    return action.products;
  }
  return product;
}

List<Product> cartReducer(List<Product> product, dynamic action) {
  if (action is ToggleProductInCartAction) {
    return action.products;
  }
  return product;
}
