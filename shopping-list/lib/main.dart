import 'package:flutter/material.dart';
import 'package:shopping_list/ui/screens/shopping_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ShoppingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}