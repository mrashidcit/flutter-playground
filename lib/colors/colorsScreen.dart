import 'package:flutter/material.dart';
import 'package:flutter_play_ground/colors/colorfulTile.dart';

class ColorsScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  List<Widget> tiles = [
    ColorfulTile(key: UniqueKey(), label: "1"),
    ColorfulTile(key: UniqueKey(), label: "2"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Colors'),
      ),
      body: Column(
        // Approach 01: Giving the list of tiles
        children: tiles,
        // Approach 02: directly palcing List here
        /**
        children: [
          ColorfulTile(key: UniqueKey()),
          ColorfulTile(key: UniqueKey()),
        ],
        */
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Swap"),
        onPressed: swapTiles,
      ),
    );
  }

  void swapTiles() {
    setState(() {
      tiles.insert(1, tiles.removeAt(0));
    });
  }
}
