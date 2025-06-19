import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String output = "0";
  String _input = "";

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        output = "0";
      } else if (buttonText == "=") {
        try {
          output = _evaluateExpression(_input);
          _input = output;
        } catch (e) {
          output = "Error";
          _input = "";
        }
      } else {
        _input += buttonText;
        output = _input;
      }
    });
  }

  String _evaluateExpression(String expr) {
    expr = expr.replaceAll(' ', '');
    if (expr.isEmpty) return "0";

    List<String> tokens = [];
    String current = "";

    for (int i = 0; i < expr.length; i++) {
      String ch = expr[i];
      if ("+-*/".contains(ch)) {
        tokens.add(current);
        tokens.add(ch);
        current = "";
      } else {
        current += ch;
      }
    }
    tokens.add(current);

    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double val = double.parse(tokens[i + 1]);

      if (op == "+") result += val;
      else if (op == "-") result -= val;
      else if (op == "*") result *= val;
      else if (op == "/") {
        if (val == 0) throw Exception("Division by zero");
        result /= val;
      }
    }

    if (result == result.roundToDouble()) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(4);
    }
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black12,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                output,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: ["7", "8", "9", "/"].map(buildButton).toList(),
          ),
          Row(
            children: ["4", "5", "6", "*"].map(buildButton).toList(),
          ),
          Row(
            children: ["1", "2", "3", "-"].map(buildButton).toList(),
          ),
          Row(
            children: ["C", "0", "=", "+"].map(buildButton).toList(),
          ),
        ],
      ),
    );
  }
}
