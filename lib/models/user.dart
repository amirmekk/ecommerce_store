import 'package:meta/meta.dart';

class User {
  String jwt, username, email, id, cartId;
  User({
    @required this.email,
    @required this.id,
    @required this.jwt,
    @required this.username,
    @required this.cartId,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        id: json['id'],
        username: json['username'],
        cartId: json['cart_id'],
        jwt: json['jwt']);
  }
}
