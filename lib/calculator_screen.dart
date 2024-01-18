import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String num1 = "";
  String operator = "";
  String num2 = "";
  String result = "";
  double fontSize = 28.0;
  double smallFontSize = 18.0;

  Widget buildContainer(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: (text == "=" || _isOperator(text))
            ? null // Si el texto es "=" o un operador, no añadir borde
            : BoxDecoration(
                border: Border.all(),
              ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: text == "=" ? smallFontSize : fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildVerticalSpace(double height) {
    return SizedBox(height: height);
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.zero,
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isOperator(String text) {
    return [
      Btn.add,
      Btn.subtract,
      Btn.multiply,
      Btn.divide,
      Btn.ax, // Puedes agregar más operadores si es necesario
    ].contains(text);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Sección de la parte superior: número1, operador, número2
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildContainer(num1),
                      buildVerticalSpace(
                          8.0), // Ajusta el espacio vertical según tus preferencias
                      buildContainer(operator),
                      buildVerticalSpace(
                          8.0), // Ajusta el espacio vertical según tus preferencias
                      buildContainer(num2),
                    ],
                  ),
                ],
              ),
            ),

            // Sección del símbolo = y resultado
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildContainer("="),
                  buildVerticalSpace(
                      8.0), // Ajusta el espacio vertical según tus preferencias
                  buildContainer(result),
                ],
              ),
            ),

            // Botones
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: (screenSize.width / 4),
                      height: (screenSize.width / 5),
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    setState(() {
      switch (value) {
        case Btn.clr:
          clear();
          break;
        case Btn.del:
          delete();
          break;
        case Btn.calculate:
          calculate();
          break;
        case Btn.ax:
          toggleSign();
          break;
        default:
          handleInput(value);
      }
    });
  }

  void clear() {
    num1 = "";
    operator = "";
    num2 = "";
    result = "";
    fontSize = 28.0;
  }

  void delete() {
    fontSize = 28.0;
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
  }

  void calculate() {
    if (num1.isNotEmpty && operator.isNotEmpty && num2.isNotEmpty) {
      fontSize = 28.0;
      try {
        double n1 = double.parse(num1);
        double n2 = double.parse(num2);

        switch (operator) {
          case Btn.add:
            result = (n1 + n2).toString();
            break;
          case Btn.subtract:
            result = (n1 - n2).toString();
            break;
          case Btn.multiply:
            result = (n1 * n2).toString();
            break;
          case Btn.divide:
            if (n2 != 0) {
              result = (n1 / n2).toString();
            } else {
              result = 'Error';
            }
            break;
          case Btn.per:
            result = (n1 * (n2 / 100)).toString();
            break;
          default:
            result = 'Error';
        }
      } catch (e) {
        result = 'Error';
      }
    }
  }

  void handleInput(String value) {
    fontSize = 28.0;
    if (isNumeric(value) || value == Btn.dot) {
      handleNumeric(value);
    } else {
      handleOperator(value);
    }
  }

  void handleNumeric(String value) {
    if (num1.isEmpty && operator.isEmpty) {
      num1 = value;
    } else if (operator.isEmpty) {
      num1 += value;
    } else if (num2.isEmpty) {
      num2 = value;
    } else if (value == Btn.dot && !num2.contains('.')) {
      num2 += value;
    } else {
      num2 += value;
    }
  }

  void handleOperator(String value) {
    if (num1.isNotEmpty && operator.isEmpty) {
      operator = value;
    } else if (num1.isNotEmpty && operator.isNotEmpty && num2.isNotEmpty) {
      calculate();
      num1 = result;
      operator = value;
      num2 = "";
    }
  }

  void toggleSign() {
    if (num1.isNotEmpty && operator.isEmpty) {
      num1 = (double.parse(num1) * -1).toString();
    } else if (num2.isNotEmpty) {
      num2 = (double.parse(num2) * -1).toString();
    }
  }

  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.redAccent
        : [
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
            Btn.ax, // Botón +/-
            Btn.per,
          ].contains(value)
            ? Colors.orange
            : Colors.lightBlue;
  }

  bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }
}
