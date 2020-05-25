import 'dart:convert';

import 'package:puzzle_Store/models/app_state.dart';
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
