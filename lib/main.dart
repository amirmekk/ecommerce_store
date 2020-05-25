import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:puzzle_Store/models/app_state.dart';
import 'package:puzzle_Store/redux/actions.dart';
import 'package:puzzle_Store/redux/reducers.dart';
import 'package:puzzle_Store/screens/log_in_screen.dart';
import 'package:puzzle_Store/screens/products_screen.dart';
import 'package:puzzle_Store/screens/sign_up_screen.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  MyApp({this.store});
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w400,
            ),
            headline2: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/products': (BuildContext context) => Products(onInit: () {
                StoreProvider.of<AppState>(context).dispatch(getUserAction);
              }),
          '/register': (BuildContext context) => SignUp(),
          '/login': (BuildContext context) => LogIn(),
        },
        //onGenerateRoute: RouteGenerator.routeGenerator,
      ),
    );
  }
}
