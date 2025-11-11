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
      home: Scaffold(body: MainView()),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Encounter encounter = _generateEncounter();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            encounter = _generateEncounter();
          }),
          child: const Text('Generate Encounter'),
        ),
        EncounterView(encounter),
      ],
    );
  }

  static Encounter _generateEncounter() {
    final type = EncounterType.values.pickRandom();
    return Encounter(type, {
      for (final action in actionsByEncounterType[type]!)
        action: Consequence.values.pickRandom(),
    });
  }
}

class EncounterView extends StatelessWidget {
  final Encounter encounter;

  const EncounterView(this.encounter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type: ${encounter.type.name}'),
        Text('Hearts: ${encounter.hearts}'),
        const Text('Actions:'),
        for (final entry in encounter.actions.entries)
          Text('${entry.key.name}: ${entry.value.name}'),
      ],
    );
  }
}

enum PlayerAction {
  sway,
  fight,
  command,
  flee,
  assess,
  athletics,
  scout,
  tinker,
}

enum Consequence { coin, heat, timer, harm, gear }

enum EncounterType { npc, obstacle, trap }

const actionsByEncounterType = <EncounterType, List<PlayerAction>>{
  EncounterType.npc: [
    PlayerAction.sway,
    PlayerAction.fight,
    PlayerAction.command,
    PlayerAction.flee,
    PlayerAction.assess,
  ],
  EncounterType.obstacle: [
    PlayerAction.athletics,
    PlayerAction.scout,
    PlayerAction.assess,
  ],
  EncounterType.trap: [
    PlayerAction.tinker,
    PlayerAction.scout,
    PlayerAction.assess,
  ],
};

class Option {
  final PlayerAction action;
  final Consequence consequence;

  Option({required this.action, required this.consequence});

  @override
  String toString() {
    return '${action.name}: ${consequence.name}';
  }
}

class Encounter {
  final int hearts = 2;
  final EncounterType type;
  final Map<PlayerAction, Consequence> actions;

  Encounter(this.type, this.actions);
}

final random = Random();

extension<T> on List<T> {
  T pickRandom() => this[random.nextInt(length)];
}
