import 'package:flutter/material.dart';
import 'package:flutter_play_ground/signUp/SignUpScreen.dart';

/// Holds the data state of [SignUpScreen].
///
/// The Password and Re-enter Password values live here instead of being read
/// through a `GlobalKey<FormFieldState>`. The confirm validator simply compares
/// against [password], and every password change notifies listeners so the
/// confirm field is rebuilt (and re-validated).
class SignUpProvider extends ChangeNotifier {
  String _fullName = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Show errors only after the first submit attempt, then live while typing.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String get fullName => _fullName;
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  AutovalidateMode get autovalidateMode => _autovalidateMode;

  // -------------------------------- Setters ----------------------------------

  // Called from onSaved, so no rebuild is needed.
  void setFullName(String value) => _fullName = value.trim();
  void setUsername(String value) => _username = value.trim();
  void setEmail(String value) => _email = value.trim();

  void setPassword(String value) {
    _password = value;
    // Rebuild so the confirm field re-validates against the new password.
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  void enableAutovalidate() {
    _autovalidateMode = AutovalidateMode.onUserInteraction;
    notifyListeners();
  }

  // ------------------------------- Validators --------------------------------

  String? validateFullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name must be at least 3 characters';
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(v)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? validateUsername(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Username is required';
    if (v.length < 3) return 'Username must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) {
      return 'Only letters, numbers and underscore (_) are allowed';
    }
    if (ExistingUsers.isUsernameTaken(v)) {
      return 'Username "$v" is already taken. Please choose another one';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v)) {
      return 'Please enter a valid email address';
    }
    if (ExistingUsers.isEmailTaken(v)) {
      return 'An account with this email already exists';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';

    final missing = <String>[];
    if (v.length < 8) missing.add('• at least 8 characters');
    if (!RegExp(r'[a-z]').hasMatch(v)) missing.add('• 1 lowercase letter');
    if (!RegExp(r'[A-Z]').hasMatch(v)) missing.add('• 1 uppercase letter');
    if (!RegExp(r'[0-9]').hasMatch(v)) missing.add('• 1 digit');
    if (!RegExp(r'[^a-zA-Z0-9\s]').hasMatch(v)) {
      missing.add('• 1 symbol (e.g. !@#\$%^&*)');
    }

    if (missing.isEmpty) return null;
    return 'Password must contain:\n${missing.join('\n')}';
  }

  String? validateConfirmPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please re-enter your password';

    // Compare with the password stored in the provider.
    if (v != _password) return 'Passwords do not match';
    return null;
  }

  // --------------------------------- Actions ---------------------------------

  /// Registers the saved account so its username/email become "taken".
  void register() => ExistingUsers.add(_username, _email);

  /// Clears all data state. Call together with FormState.reset().
  void reset() {
    _fullName = '';
    _username = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _autovalidateMode = AutovalidateMode.disabled;
    notifyListeners();
  }
}

/// In-memory "database" of accounts that already exist.
/// Used to check whether a username / email is already taken.
class ExistingUsers {
  static final List<Map<String, String>> users = [
    {'username': 'rashid', 'email': 'rashid@example.com'},
    {'username': 'ali_khan', 'email': 'ali.khan@example.com'},
    {'username': 'sara123', 'email': 'sara@example.com'},
    {'username': 'john_doe', 'email': 'john.doe@example.com'},
  ];

  static bool isUsernameTaken(String username) => users.any(
    (u) => u['username']!.toLowerCase() == username.trim().toLowerCase(),
  );

  static bool isEmailTaken(String email) =>
      users.any((u) => u['email']!.toLowerCase() == email.trim().toLowerCase());

  static void add(String username, String email) =>
      users.add({'username': username.trim(), 'email': email.trim()});
}
