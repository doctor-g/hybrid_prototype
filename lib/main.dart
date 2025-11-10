import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hybrid Prototype',
      home: Scaffold(body: EncounterView()),
    );
  }
}

class EncounterView extends StatelessWidget {
  const EncounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('This is it.');
  }
}
