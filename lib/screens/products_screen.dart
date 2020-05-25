import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:puzzle_Store/models/app_state.dart';

class Products extends StatefulWidget {
  final void Function() onInit;
  Products({this.onInit});
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return state.user == null
            ? Text('null value')
            : Text(state.user.username);
      },
    );
  }
}
