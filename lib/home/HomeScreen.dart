import 'package:flutter/material.dart';
import 'package:flutter_play_ground/fruit/FruitsScreen.dart';
import 'package:flutter_play_ground/scaffoldMessenger/ScaffoldMessengerTestScreen.dart';
import 'package:flutter_play_ground/signUp/SignUpScreen.dart';

/// First screen of the app. Lets the user pick which demo screen to open.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => _open(context, const SignUpScreen()),
                child: const Text('SignUp'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => _open(context, const FruitsScreen()),
                child: const Text('Fruit'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    _open(context, const ScaffoldMessengerTestScreen()),
                child: const Text('ScaffoldMessanger Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
