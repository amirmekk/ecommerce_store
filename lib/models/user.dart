import 'package:meta/meta.dart';

class User {
  String jwt, username, email, id, cartId, stripeId;
  User({
    @required this.email,
    @required this.id,
    @required this.jwt,
    @required this.username,
    @required this.cartId,
    @required this.stripeId,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['_id'],
        username: json['username'],
        cartId: json['cart_id'],
        stripeId: json['stripe_id'],
        jwt: json['jwt']);
  }
}
