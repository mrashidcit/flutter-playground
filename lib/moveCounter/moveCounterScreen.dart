import 'package:flutter/material.dart';
import 'package:flutter_play_ground/moveCounter/counterCard.dart';

class MoveCounterScreen extends StatefulWidget {
  const MoveCounterScreen({super.key});

  @override
  State<MoveCounterScreen> createState() => _MoveCounterScreenState();
}

class _MoveCounterScreenState extends State<MoveCounterScreen> {
  final GlobalKey<CounterCardState> _counterKey = GlobalKey<CounterCardState>();

  bool _isInContainerA = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GlobalKey Demo')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isInContainerA = !_isInContainerA;
              });
            },
            child: const Text('Move Counter'),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue.shade100,
                    child: Column(
                      children: [
                        const Text('Container A'),
                        if (_isInContainerA) CounterCard(key: _counterKey),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.orange.shade100,
                    child: Column(
                      children: [
                        const Text('Container B'),
                        if (!_isInContainerA) CounterCard(key: _counterKey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
