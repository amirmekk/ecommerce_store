import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/models/user.dart';
import 'package:puzzle_Store/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(user: userReducer(state.user, action));
}

User userReducer(User user, dynamic action) {
  if (action is GetUserAction) {
    return action.user;
  }
  return user;
}
