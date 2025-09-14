import 'package:flutter/material.dart';
import 'package:multicalc/pages/exercise_one.dart';
import 'package:multicalc/pages/exercise_two.dart';
import 'package:multicalc/pages/exercise_three.dart';
import 'package:multicalc/pages/exercise_four.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MultiCalc',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Widget> getButtons(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 243, 33, 233),
      padding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    const buttonPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0);

    return [
      Padding(
      padding: buttonPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExerciseOnePage())),
        child: const Text("Conversor Celsius → Fahrenheit"),
        ),
      ),
      ),
      Padding(
      padding: buttonPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExerciseTwoPage())),
        child: const Text("Calculadora de Média"),
        ),
      ),
      ),
      Padding(
      padding: buttonPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExerciseThreePage())),
        child: const Text("Calculadora de Desconto"),
        ),
      ),
      ),
      Padding(
      padding: buttonPadding,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: buttonStyle,
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExerciseFourPage())),
        child: const Text("Área de Retângulo"),
        ),
      ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MultiCalc"),
        backgroundColor: const Color.fromARGB(255, 243, 33, 233),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        const Icon(Icons.calculate, size: 104, color: Color.fromARGB(255, 243, 33, 233)),
        ...getButtons(context),
          ],
        ),
      ),
    );
  }
}

