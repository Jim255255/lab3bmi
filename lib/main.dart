//TODO 1: Import the math library for the pow function
import 'dart:math';

import 'package:flutter/material.dart';

import 'info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Body Mass Index'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Acceptable input ranges used by the validation
  static const double _minWeight = 1.0; // kg
  static const double _maxWeight = 500.0; // kg
  static const double _minHeight = 0.5; // meter
  static const double _maxHeight = 2.5; // meter

  //TODO 2: Declare local variable
  double _bmi = 0.0;
  double _weight = 0.0;
  double _height = 0.0;

  String _bmiOutput = '';
  String _bmiImage = 'assets/images/empty.png';

  // Error messages shown under the text fields (null = no error)
  String? _weightError;
  String? _heightError;

  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _heightCtrl = TextEditingController();

  // Range field validation: returns an error message, or null if the value is valid
  String? _validateRange(String input, String name, double min, double max) {
    final value = double.tryParse(input.trim());
    if (input.trim().isEmpty) {
      return 'Please enter your $name';
    }
    if (value == null) {
      return 'Please enter a valid number';
    }
    if (value < min || value > max) {
      return 'The $name must be between $min and $max';
    }
    return null;
  }

  //TODO 3: Calculate BMI value
  void _calculateBMI() {
    final weightError =
    _validateRange(_weightCtrl.text, 'weight', _minWeight, _maxWeight);
    final heightError =
    _validateRange(_heightCtrl.text, 'height', _minHeight, _maxHeight);

    // Stop here if any input is invalid, and show the error messages
    if (weightError != null || heightError != null) {
      setState(() {
        _weightError = weightError;
        _heightError = heightError;
        _bmi = 0.0;
        _bmiOutput = '';
        _bmiImage = 'assets/images/empty.png';
      });
      return;
    }

    _weight = double.tryParse(_weightCtrl.text.trim()) ?? 0.0;
    _height = double.tryParse(_heightCtrl.text.trim()) ?? 0.0;

    setState(() {
      _weightError = null;
      _heightError = null;

      _bmi = _weight / pow(_height, 2);

      if (_bmi < 18.5) {
        _bmiImage = 'assets/images/under.png';
        _bmiOutput = '${_bmi.toStringAsFixed(2)} [Underweight]';
      } else if (_bmi >= 25) {
        _bmiImage = 'assets/images/over.png';
        _bmiOutput = '${_bmi.toStringAsFixed(2)} [Overweight]';
      } else {
        _bmiImage = 'assets/images/normal.png';
        _bmiOutput = '${_bmi.toStringAsFixed(2)} [Normal]';
      }
    });
  }

  //TODO 4: Reset all widgets
  void _resetScreen() {
    _weightCtrl.clear();
    _heightCtrl.clear();
    setState(() {
      _bmi = 0.0;
      _bmiOutput = '';
      _bmiImage = 'assets/images/empty.png';
      _weightError = null;
      _heightError = null;
    });
  }

  //TODO 5: Override the dispose method
  @override
  void dispose() {
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO 6: set resize of screen to avoid overflow issue
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        //TODO 7: Insert a Padding widget
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TODO 8: Insert Stack with image and text
              Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.center,
                children: [
                  //TODO 9: Insert two containers
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.asset(
                      _bmiImage,
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.center,
                    child: _bmi == 0.0
                        ? const Text(
                      textAlign: TextAlign.center,
                      'Enter body weight and height to know your Body Mass Index (BMI)',
                      style:
                      TextStyle(fontSize: 12, color: Colors.orange),
                    )
                        : const Text(''),
                  ),
                ],
              ),

              //TODO 10: Insert text widget showing BMI status
              const Text(
                'You Body Mass Index (BMI) is :',
              ),
              Text(
                _bmiOutput,
                style: Theme.of(context).textTheme.displaySmall,
              ),

              //TODO 11: Insert TextField and Button
              TextField(
                controller: _weightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter weight (kg)',
                  errorText: _weightError,
                ),
              ),
              TextField(
                controller: _heightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter height (meter)',
                  errorText: _heightError,
                ),
              ),

              //TODO 12: Insert an Expanded widget to take up empty screen spaces
              const Expanded(child: SizedBox(height: double.infinity)),

              IconButton(
                icon: Icon(Icons.info),
                iconSize: 48,
                color: Colors.orangeAccent,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Info(bmi: _bmiOutput,)));
                },
              ),

              //TODO 13: Insert reset and calculate buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _resetScreen, child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: _calculateBMI,
                      child: const Text('Calculate')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}