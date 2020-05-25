import 'package:meta/meta.dart';

class User {
  String jwt, username, email, id;
  User(
      {@required this.email,
      @required this.id,
      @required this.jwt,
      @required this.username});
  factory User.fromJson(Map<String , dynamic>json) {
    return User(
        email: json['email'],
        id: json['id'],
        username: json['username'],
        jwt: json['jwt']);
  }
}
