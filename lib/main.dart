import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Body Mass Index'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _weight = 0.0;
  double _height = 0.0;


  double _bmi = 0.0;
  String _bmiImage = "assets/images/empty.png";
  String _bmiOutput = "";

  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  void _calculateBMI() {
    _weight = double.tryParse(_weightCtrl.text)!;
    _height = double.tryParse(_heightCtrl.text)!;
    _bmi = _weight/pow(_height/100, 2);
    setState(() {
      if(_bmi < 18.5){
        _bmiImage = "assets/images/under.png";
        _bmiOutput = "${_bmi.toStringAsFixed(2)} [Underweight]";
      }else if(_bmi >= 18.5 && _bmi <= 24.9){
        _bmiImage = "assets/images/normal.png";
        _bmiOutput = "${_bmi.toStringAsFixed(2)} [Normal]";
      }else{
        _bmiImage = "assets/images/over.png";
        _bmiOutput = "${_bmi.toStringAsFixed(2)} [Overweight]";
      }
    });
  }

  void _resetScreen(){
    _weightCtrl.clear();
    _heightCtrl.clear();
    _bmi = 0.0;
    setState(() {
      _bmiImage = "assets/images/empty.png";
      _bmiOutput = "";
    });
  }

  @override void dispose() {
    super.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 8,
            children: [
              Image.asset(_bmiImage),
              const Text('Your body mass index is: '),
              Text(
                _bmiOutput,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextField(
                controller: _weightCtrl,
                decoration: InputDecoration(
                  label: Text("Weight (kg)")
                ),
              ),
          TextField(
          controller: _heightCtrl,
          decoration: InputDecoration(
            label: Text("Height (cm)")
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  ElevatedButton(onPressed: _calculateBMI, child: Text("Calculate BMI")),
                  ElevatedButton(onPressed: _resetScreen, child: Text("Reset")
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
