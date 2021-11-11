import 'package:flutter/material.dart';
import 'dart:math';

import 'package:telly/home.dart';
import 'package:telly/game.dart';

void main() {
  runApp(MyApp());
}

// add two routes

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // final rand = Random();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telly!',
      theme: ThemeData(
        primarySwatch: ([...Colors.primaries]..shuffle()).first,
        fontFamily: 'Covered',
      ),
      home: Home(),
      // defaultRoute: '/home',
      routes: {'/home': (context) => Home(), '/game': (context) => Game()},
    );
  }
}
