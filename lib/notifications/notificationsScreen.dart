import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey<String>('notifications_tab'),
      itemCount: 50,
      itemBuilder: (context, index) => ListTile(title: Text('Alert $index')),
    );
  }
}
