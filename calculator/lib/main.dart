
import 'package:flutter/material.dart';

void main() {
  runApp(const Layout());
}

class Layout extends StatelessWidget {
  const Layout({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const Calculator(title: 'Calculadora de Soma'),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key, required this.title});
  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String resultado = '';
  List<int> numeros = [];
  List<int> lixo = [];

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
      } else if(value == 'C'){
          lixo.add(int.parse(resultado));
          lixo.clear;
          resultado = '';
        }
       else {
        resultado += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            resultado,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              children: [
                for (var text in ['0','1','2','3','4','5','6','7','8','9','+','=', 'C'])
                  ElevatedButton(
                    onPressed: () => _onButtonPressed(text),
                    child: Text(text, style: const TextStyle(fontSize: 24)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
