import 'package:flutter/material.dart';
import 'widgets/Coordinates/map.dart';

void main() {
  runApp(
    new HomeApp(),
  );
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tutorials',
      home: new MapSample(),
    );
  }
}
