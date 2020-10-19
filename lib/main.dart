import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies Application',
      theme: ThemeData(
        primaryColor: Color(0xFF151C26),
        accentColor: Color(0xFFF4C10F),
        textTheme: TextTheme(headline6: TextStyle(color: Color(0xFF5A686B))),
      ),
      home: HomeScreen(),
    );
  }
}
