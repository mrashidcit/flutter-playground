import 'package:flutter/material.dart';

class CounterCard extends StatefulWidget {
  const CounterCard({super.key});

  @override
  State<CounterCard> createState() => CounterCardState();
}

class CounterCardState extends State<CounterCard> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('CounterCard: initState');
  }

  @override
  void dispose() {
    debugPrint('CounterCard: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Count: $count'),
            ElevatedButton(
              onPressed: () {
                setState(() => count++);
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
