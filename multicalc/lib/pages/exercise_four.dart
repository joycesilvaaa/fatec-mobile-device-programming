import 'package:flutter/material.dart';
import 'package:multicalc/models/base.dart';
import 'package:multicalc/widgets/button.dart';


class ExerciseFourPage extends CalculateBasePage {
  const ExerciseFourPage({super.key});

  @override
  State<ExerciseFourPage> createState() => _ExerciseFourPageState();
}

class _ExerciseFourPageState extends CalculateBaseState<ExerciseFourPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void calculate() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if(weight != null && height != null){
      final area = weight * height;
      result = 'Área: $area';
    } else {
      setState(() {
        result = 'Valor inválido!';
      });
    }
  }

  @override
  void reset() {
    _weightController.clear();
    _heightController.clear();
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
              controller: _weightController,
                style: const TextStyle(fontSize: 24),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Largura',
                  labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: _heightController,
                style: const TextStyle(fontSize: 24),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Altura',
                  labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
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