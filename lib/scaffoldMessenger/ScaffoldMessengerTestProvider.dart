import 'package:flutter/material.dart';
import 'package:flutter_play_ground/main.dart';
import 'package:flutter_play_ground/scaffoldMessenger/ScaffoldMessengerTestScreen.dart';

/// Holds the state of [ScaffoldMessengerTestScreen].
class ScaffoldMessengerTestProvider extends ChangeNotifier {
  bool _isUploading = false;

  bool get isUploading => _isUploading;

  // --------------------------------- Actions ---------------------------------

  /// Fakes an upload and shows SnackBars from inside the provider.
  Future<void> upload() async {
    if (_isUploading) return;
    _isUploading = true;
    notifyListeners();

    _showSnackBar('Uploading .....');

    // No BuildContext is needed after the await, so there is no
    // "use_build_context_synchronously" problem here.
    await Future.delayed(const Duration(seconds: 2));

    _isUploading = false;
    notifyListeners();

    _showSnackBar('Upload complete');
  }

  void _showSnackBar(String msg) {
    // currentState is null until MaterialApp has been built.
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }
}
