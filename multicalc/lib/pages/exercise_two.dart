import 'package:flutter/material.dart';
import 'package:multicalc/models/base.dart';
import 'package:multicalc/widgets/button.dart';

class ExerciseTwoPage extends CalculateBasePage {
  const ExerciseTwoPage({super.key});

  @override
  State<ExerciseTwoPage> createState() => _ExerciseTwoPageState();
}

class _ExerciseTwoPageState extends CalculateBaseState<ExerciseTwoPage> {
  final _numberOneController = TextEditingController();
  final _numberTwoController = TextEditingController();
  final _numberThreeController = TextEditingController();

  @override
  void calculate() {
    final numberOne = double.tryParse(_numberOneController.text);
    final numberTwo = double.tryParse(_numberTwoController.text);
    final numberThree = double.tryParse(_numberThreeController.text);
    if(numberOne != null && numberTwo != null && numberThree != null){
      final average = (numberOne + numberTwo + numberThree) / 3;
      result = 'Média: $average';
    } else {
      setState(() {
        result = 'Valor inválido!';
      });
    }
  }

  @override
  void reset() {
    _numberOneController.clear();
    _numberTwoController.clear();
    _numberThreeController.clear();
    super.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Média')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberOneController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Número 1', labelStyle: TextStyle(fontSize: 20),
                ),
            ),
            TextField(
              controller: _numberTwoController,
              keyboardType: TextInputType.number,
              
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Número 2', labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: _numberThreeController,
              keyboardType: TextInputType.number,
              
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Número 3', labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Calcular',
              onPressed: () {
                calculate();
                setState(() {});
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Resetar',
              onPressed: reset,
            ),
            if (result.isNotEmpty)
              Text(
                result,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}