import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.from(alpha: 1, red: 0.2, green: 0.2, blue: 0.5),
          foregroundColor: Color(0xffffffff),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("hello")),
        body: Center(child: Text("Go Sleep")),
      ),
    );
  }
}
