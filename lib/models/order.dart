import 'package:meta/meta.dart';

class Order {
  final double amount;
  final List<dynamic> products;
  final String createdAt;
  Order(
      {@required this.amount,
      @required this.createdAt,
      @required this.products});
  factory Order.fromJson(json) {
    return Order(
      amount: json['amount'],
      products: json['products'],
      createdAt: json['createdAt'],
    );
  }
}
