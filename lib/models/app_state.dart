import 'package:flutter/cupertino.dart';

@immutable
class AppState {
  final dynamic user;
  AppState({@required this.user});
  factory AppState.initial() {
    return AppState(user: null);
  }
}
