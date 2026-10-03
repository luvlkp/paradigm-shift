import 'package:flutter/material.dart';
import 'home_page.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paradigm Shift',
      theme: groveTheme(),
      home: const HomePage(),
    );
  }
}
