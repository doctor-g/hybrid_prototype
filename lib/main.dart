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
  late bool detected;
  late Disposition disposition;
  final List<Option> options = [];

  @override
  void initState() {
    super.initState();
    _randomize();
  }

  void _randomize() {
    Consequence anyDangerousConsequence() => [
      Consequence.timer,
      Consequence.harm,
      Consequence.gear,
      Consequence.heat,
    ].pickRandom();

    disposition = Disposition.neutral;
    detected = random.nextDouble() <= 0.5;
    options.clear();

    if (disposition == Disposition.neutral) {
      options.addAll([
        Option(
          action: PlayerAction.sway,
          consequence: [
            Consequence.coin,
            Consequence.timer,
            Consequence.heat,
          ].pickRandom(),
        ),
        Option(
          action: PlayerAction.command,
          consequence: [
            Consequence.coin,
            Consequence.timer,
            Consequence.heat,
            Consequence.harm,
          ].pickRandom(),
        ),
      ]);
    } else {
      throw UnimplementedError(
        'Only neutral disposition has been coded so far.',
      );
    }

    options.addAll([
      Option(
        action: PlayerAction.skirmish,
        consequence: anyDangerousConsequence(),
      ),
      Option(
        action: PlayerAction.prowl,
        consequence: anyDangerousConsequence(),
      ),
    ]);
    if (!detected) {
      options.add(
        Option(
          action: PlayerAction.hunt,
          consequence: anyDangerousConsequence(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Disposition: ${disposition.name}'),
        Text(detected ? 'Detected' : 'Undetected'),
        for (final option in options) Text(option.toString()),
        ElevatedButton(
          onPressed: () => setState(_randomize),
          child: const Text('Randomize'),
        ),
      ],
    );
  }
}

enum Disposition { friendly, neutral, cautious, aggressive }

enum PlayerAction { sway, command, hunt, skirmish, prowl }

enum Consequence { coin, heat, timer, harm, gear }

class Option {
  final PlayerAction action;
  final int modifier;
  final Consequence consequence;

  Option({required this.action, required this.consequence, this.modifier = 0});

  @override
  String toString() {
    return '${action.name}${switch (modifier) {
      < 0 => '$modifier',
      > 0 => '+$modifier',
      int() => '',
    }}: ${consequence.name}';
  }
}

final random = Random();

extension<T> on List<T> {
  T pickRandom() => this[random.nextInt(length)];
}
