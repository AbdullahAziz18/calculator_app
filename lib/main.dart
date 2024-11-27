import 'package:calculator_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String displayText = "0";
  String operator = "";
  double firstNumber = 0;
  double secondNumber = 0;
  bool isOpenParenthesis = true; // Track the parentheses state

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        displayText = "0";
        operator = "";
        firstNumber = 0;
        secondNumber = 0;
        isOpenParenthesis = true; // Reset parentheses state
      } else if (buttonText == "⌫") {
        displayText = displayText.length > 1
            ? displayText.substring(0, displayText.length - 1)
            : "0";
      } else if (buttonText == "%") {
        displayText = (double.parse(displayText) / 100).toString();
      } else if (buttonText == "(" || buttonText == ")") {
        displayText += buttonText;
        isOpenParenthesis = !isOpenParenthesis; // Toggle parentheses state
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "x" ||
          buttonText == "/") {
        firstNumber = double.parse(displayText);
        operator = buttonText;
        displayText = "0";
      } else if (buttonText == "=") {
        secondNumber = double.parse(displayText);

        if (operator == "+") {
          displayText = (firstNumber + secondNumber).toString();
        } else if (operator == "-") {
          displayText = (firstNumber - secondNumber).toString();
        } else if (operator == "x") {
          displayText = (firstNumber * secondNumber).toString();
        } else if (operator == "/") {
          displayText = (firstNumber / secondNumber).toString();
        }

        operator = "";
        firstNumber = 0;
        secondNumber = 0;
      } else {
        if (displayText == "0" && buttonText != ".") {
          displayText = buttonText;
        } else if (buttonText == "." && !displayText.contains(".")) {
          displayText += ".";
        } else if (buttonText != ".") {
          displayText += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, Color buttonColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(20.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 30.0, color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                displayText,
                style: const TextStyle(
                    fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("C", Colors.black54, Colors.white),
                  buildButton(isOpenParenthesis ? "(" : ")", Colors.black38,
                      Colors.white),
                  buildButton("%", Colors.black38, Colors.white),
                  buildButton("/", Colors.black38, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("7", Colors.grey.shade400, Colors.black),
                  buildButton("8", Colors.grey.shade400, Colors.black),
                  buildButton("9", Colors.grey.shade400, Colors.black),
                  buildButton("x", Colors.black38, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.grey.shade400, Colors.black),
                  buildButton("5", Colors.grey.shade400, Colors.black),
                  buildButton("6", Colors.grey.shade400, Colors.black),
                  buildButton("-", Colors.black38, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.grey.shade400, Colors.black),
                  buildButton("2", Colors.grey.shade400, Colors.black),
                  buildButton("3", Colors.grey.shade400, Colors.black),
                  buildButton("+", Colors.black38, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("0", Colors.grey.shade400, Colors.black),
                  buildButton(".", Colors.grey.shade400, Colors.black),
                  buildButton("⌫", Colors.grey.shade400, Colors.black),
                  buildButton("=", Colors.black, Colors.white),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
