import 'package:flutter/material.dart';
import 'page/listMatches.dart';

//Qibran Idza Lafandzi - 123200141

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'World Cup 2022',
        theme: ThemeData(
        primaryColor: Colors.blue,
    ),
    home: listMatches(),
    );
  }
}