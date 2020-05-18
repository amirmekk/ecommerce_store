import 'package:flutter/material.dart';
import 'package:puzzle_Store/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
