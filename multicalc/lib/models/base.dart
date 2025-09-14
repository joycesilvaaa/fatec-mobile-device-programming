import 'package:flutter/material.dart';

abstract class CalculateBasePage extends StatefulWidget {
  const CalculateBasePage({super.key});
}


abstract class CalculateBaseState<T extends CalculateBasePage> extends State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String result = '';

  @override
  Widget build(BuildContext context);
  
  void calculate();

  void reset() {
    formKey.currentState?.reset();
    setState(() {
      result = '';
    });
  }
}


