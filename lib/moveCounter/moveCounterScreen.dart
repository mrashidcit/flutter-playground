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
                  child: _buildDropContainer(
                    label: 'Container A',
                    color: Colors.blue.shade100,
                    isContainerA: true,
                  ),
                ),
                Expanded(
                  child: _buildDropContainer(
                    label: 'Container B',
                    color: Colors.orange.shade100,
                    isContainerA: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropContainer({
    required String label,
    required Color color,
    required bool isContainerA,
  }) {
    final bool hasCounter = _isInContainerA == isContainerA;

    return DragTarget<GlobalKey<CounterCardState>>(
      // Only accept the card when it's coming from the other container
      onWillAcceptWithDetails: (_) => !hasCounter,
      onAcceptWithDetails: (_) {
        setState(() {
          _isInContainerA = isContainerA;
        });
      },
      builder: (context, candidateData, rejectedData) {
        final bool isHovering = candidateData.isNotEmpty;

        return Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: isHovering ? Colors.green : Colors.transparent,
              width: 3,
            ),
          ),
          child: Column(
            children: [Text(label), if (hasCounter) _buildDraggableCounter()],
          ),
        );
      },
    );
  }

  Widget _buildDraggableCounter() {
    // The GlobalKey keeps the same CounterCardState when the card is
    // reparented into the other container after a drop.
    final counter = CounterCard(key: _counterKey);

    return Draggable<GlobalKey<CounterCardState>>(
      data: _counterKey,
      // Feedback can't reuse the GlobalKey (it would exist twice in the tree),
      // so render a plain preview using the current state's count.
      feedback: Material(
        color: Colors.transparent,
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Count: ${_counterKey.currentState?.count ?? 0}'),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: counter),
      child: counter,
    );
  }
}
