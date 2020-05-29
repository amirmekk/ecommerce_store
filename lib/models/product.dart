import 'package:meta/meta.dart';

class Product {
  String id, name, description;
  List<dynamic> picture;
  double price;
  Product(
      {@required this.name,
      @required this.id,
      @required this.description,
      @required this.picture,
      @required this.price});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'],
        id: json['id'],
        description: json['description'],
        picture: json['picture'],
        price: json['price']);
  }
}
