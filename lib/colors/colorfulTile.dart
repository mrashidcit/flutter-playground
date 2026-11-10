import 'dart:math';

import 'package:flutter/material.dart';

class ColorfulTile extends StatefulWidget {
  late String label;

  ColorfulTile({super.key, required this.label});

  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  late final Color color;

  @override
  void initState() {
    super.initState();
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      color: color,
      child: Center(child: Text(widget.label)),
    );
  }
}
