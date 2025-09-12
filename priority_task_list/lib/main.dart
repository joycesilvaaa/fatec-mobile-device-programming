import 'package:flutter/material.dart';
import 'screens/ebook_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor de E-books',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EbookListScreen(),
    );
  }
}