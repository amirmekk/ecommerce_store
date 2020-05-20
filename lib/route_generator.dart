import 'package:flutter/material.dart';
import 'package:puzzle_Store/screens/log_in_screen.dart';
import 'package:puzzle_Store/screens/sign_up_screen.dart';

class RouteGenerator {
  static Route<dynamic> routeGenerator(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SignUp());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignUp());  
      case '/login':
        return MaterialPageRoute(builder: (_) => LogIn());

      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(title: Text('error')),
    );
  });
}
