import 'package:flutter/material.dart';

class PostsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey<String>('feed_tab'),
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(title: Text('Post $index')),
    );
  }
}
