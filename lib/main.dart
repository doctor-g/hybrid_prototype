import 'dart:math';

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

class EncounterView extends StatefulWidget {
  const EncounterView({super.key});

  @override
  State<EncounterView> createState() => _EncounterViewState();
}

class _EncounterViewState extends State<EncounterView> {
  final List<Option> options = [];

  @override
  void initState() {
    super.initState();
    _randomize();
  }

  void _randomize() {
    options
      ..clear()
      ..addAll([
        for (final action in PlayerAction.values)
          Option(action, Consequence.values.pickRandom()),
      ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in options)
          Text('${option.action.name}: ${option.consequence.name}'),
        ElevatedButton(
          onPressed: () => setState(_randomize),
          child: const Text('Randomize'),
        ),
      ],
    );
  }
}

enum PlayerAction { sway, command, hunt, skirmish, prowl }

enum Consequence { heat, timer, harm, gear }

class Option {
  final PlayerAction action;
  final Consequence consequence;

  Option(this.action, this.consequence);

  factory Option.of(PlayerAction action, List<Consequence> consequences) {
    return Option(action, consequences.pickRandom());
  }
}

extension<T> on List<T> {
  static final _random = Random();

  T pickRandom() => this[_random.nextInt(length)];
}
