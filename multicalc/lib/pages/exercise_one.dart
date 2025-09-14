import 'package:flutter/material.dart';
import 'package:multicalc/models/base.dart';
import 'package:multicalc/widgets/button.dart';

class ExerciseOnePage extends CalculateBasePage {
  const ExerciseOnePage({super.key});

  @override
  State<ExerciseOnePage> createState() => _ExerciseOnePageState();
}

class _ExerciseOnePageState extends CalculateBaseState<ExerciseOnePage> {
  final _celsiusController = TextEditingController();

  @override
  void calculate() {
    final celsius = double.tryParse(_celsiusController.text);
    if(celsius != null){
      final fahrenheit = (celsius * 9/5) + 32;
      result = '$celsius °C = $fahrenheit °F';
    } else {
      setState(() {
        result = 'Valor inválido!';
      });
    }
  }

  @override
  void reset() {
    _celsiusController.clear();
    super.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor Celsius → Fahrenheit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
                TextFormField(
                controller: _celsiusController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  labelText: 'Temperatura em Celsius',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Por favor, insira um valor';
                  }
                  if (double.tryParse(value) == null) {
                  return 'Por favor, insira um número válido';
                  }
                  return null;
                },
                ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Converter',
                onPressed: () {
                  if(formKey.currentState?.validate() ?? false){
                    calculate();
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Resetar',
                onPressed: reset,
              ),
              const SizedBox(height: 10),
              if(result.isNotEmpty)
                Text(
                  result,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}