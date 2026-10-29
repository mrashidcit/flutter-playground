import 'package:flutter/material.dart';
import 'package:flutter_play_ground/scaffoldMessenger/ScaffoldMessengerTestProvider.dart';
import 'package:provider/provider.dart';

/// Demo screen to learn `ScaffoldMessenger`.
///
/// `ScaffoldMessenger.of(context)` finds the nearest ScaffoldMessenger (the one
/// MaterialApp creates for us) and uses it to show SnackBars and
/// MaterialBanners on the current Scaffold.
class ScaffoldMessengerTestScreen extends StatefulWidget {
  const ScaffoldMessengerTestScreen({super.key});

  @override
  State<ScaffoldMessengerTestScreen> createState() =>
      _ScaffoldMessengerTestScreenState();
}

class _ScaffoldMessengerTestScreenState
    extends State<ScaffoldMessengerTestScreen> {
  // Saved so we can clear the banner in dispose(), where `context` must not be
  // used to look up ancestors.
  late ScaffoldMessengerState _messenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    // A MaterialBanner stays visible until it is hidden, even after this route
    // is popped (it moves to the previous Scaffold). Remove it when we leave.
    _messenger.removeCurrentMaterialBanner();
    super.dispose();
  }

  // -------------------------------- SnackBar ---------------------------------

  void _showSnackBar(String msg) {
    // Hide the current SnackBar first, otherwise new ones are queued and shown
    // one after another.
    _messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ----------------------------- MaterialBanner ------------------------------

  void _showNoInternetBanner() {
    _messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          leading: const Icon(Icons.wifi_off),
          content: const Text('No Internet connection'),
          actions: [TextButton(onPressed: _retry, child: const Text('Retry'))],
          overflowAlignment: OverflowBarAlignment.center,
        ),
      );
  }

  void _retry() {
    // Unlike a SnackBar, a MaterialBanner never hides by itself.
    _messenger
      ..hideCurrentMaterialBanner()
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Retrying...')));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read<ScaffoldMessengerTestProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ScaffoldMessenger Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () {
                  _showSnackBar('Loading .....');
                },
                child: const Text('Load'),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _showNoInternetBanner,
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
              // The SnackBars for Upload are shown by the provider itself.
              FilledButton(
                onPressed: provider.isUploading ? null : provider.upload,
                child: Text(provider.isUploading ? 'Uploading...' : 'Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
