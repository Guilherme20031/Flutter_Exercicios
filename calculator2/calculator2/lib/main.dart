
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CalcLayout(),
    );
  }
}

class CalcLayout extends StatefulWidget {
  const CalcLayout({super.key});

  @override
  State<CalcLayout> createState() => _CalcLayoutState();
}

class _CalcLayoutState extends State<CalcLayout> {
  String resultado = '';
  List<int> numeros = [];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == '+') {
        if (resultado.isNotEmpty) {
          numeros.add(int.parse(resultado));
          resultado = '';
        }
      } else if (value == '=') {
        if (resultado.isNotEmpty) {
          numeros.add(int.parse(resultado));
        }
        int soma = numeros.fold(0, (a, b) => a + b);
        resultado = soma.toString();
        numeros.clear();
      } else if (value == 'C') {
        resultado = '';
        numeros.clear();
      } else {
        resultado += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Calculadora')),
      ),
      body: Column(
        children: [
          ColoredBox(
            color: Colors.yellow,
            child: const SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text('Só aceita operações de soma (é fraca)'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            resultado.isEmpty ? "Resultado" : resultado,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                for (var text in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '=', 'C'])
                  ElevatedButton(
                    onPressed: () => _onButtonPressed(text),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
