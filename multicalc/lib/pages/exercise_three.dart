import 'package:flutter/material.dart';
import 'package:multicalc/models/base.dart';
import 'package:multicalc/widgets/button.dart';

class ExerciseThreePage extends CalculateBasePage {
  const ExerciseThreePage({super.key});

  @override
  State<ExerciseThreePage> createState() => _ExerciseThreePageState();
}

class _ExerciseThreePageState extends CalculateBaseState<ExerciseThreePage> {
  final _discountController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void calculate() {
    final discount = double.tryParse(_discountController.text);
    final price = double.tryParse(_priceController.text);
    if(discount != null && price != null){
      final finalPrice = price - (price * discount / 100);
      result = 'Preço final: $finalPrice';
    } else {
      setState(() {
        result = 'Valor inválido!';
      });
    }
  }

  @override
  void reset() {
    _discountController.clear();
    _priceController.clear();
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
              controller: _discountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Desconto (%)',
                  labelStyle: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                labelText: 'Preço',
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