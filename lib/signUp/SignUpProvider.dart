import 'package:flutter/material.dart';
import 'package:flutter_play_ground/signUp/SignUpScreen.dart';

/// Holds ALL the state of [SignUpScreen]: field values, validation errors,
/// password visibility and the "form version" used to clear the fields.
///
/// No `GlobalKey<FormState>` / `GlobalKey<FormFieldState>` is needed:
/// - every field pushes its value here through onChanged,
/// - the screen reads each field's error from the `...Error` getters,
/// - [submit] validates everything at once (what FormState.validate() did),
/// - [reset] clears the data and bumps [formVersion] so the screen recreates
///   its TextFields empty (what FormState.reset() did).
class SignUpProvider extends ChangeNotifier {
  String _fullName = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Show errors only after the first submit attempt, then live while typing.
  bool _submitted = false;

  // Used as a ValueKey by the screen. Changing it throws away the old
  // TextFields (and the text inside them) and builds fresh, empty ones.
  int _formVersion = 0;

  String get fullName => _fullName;
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  int get formVersion => _formVersion;

  // --------------------------------- Errors ----------------------------------
  // null means "no error to show" (either valid, or not submitted yet).

  String? get fullNameError => _submitted ? _validateFullName(_fullName) : null;
  String? get usernameError => _submitted ? _validateUsername(_username) : null;
  String? get emailError => _submitted ? _validateEmail(_email) : null;
  String? get passwordError => _submitted ? _validatePassword(_password) : null;

  // Like before: once the user has typed here, check it live (also when the
  // password above changes), even before the first submit.
  String? get confirmPasswordError =>
      _submitted || _confirmPassword.isNotEmpty
          ? _validateConfirmPassword(_confirmPassword)
          : null;

  bool get _isValid =>
      _validateFullName(_fullName) == null &&
      _validateUsername(_username) == null &&
      _validateEmail(_email) == null &&
      _validatePassword(_password) == null &&
      _validateConfirmPassword(_confirmPassword) == null;

  // -------------------------------- Setters ----------------------------------
  // Each change rebuilds the screen so the errors above stay up to date.

  void setFullName(String value) {
    _fullName = value.trim();
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value.trim();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value.trim();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
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

  // ------------------------------- Validators --------------------------------

  String? _validateFullName(String v) {
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name must be at least 3 characters';
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(v)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateUsername(String v) {
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

  String? _validateEmail(String v) {
    if (v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(v)) {
      return 'Please enter a valid email address';
    }
    if (ExistingUsers.isEmailTaken(v)) {
      return 'An account with this email already exists';
    }
    return null;
  }

  String? _validatePassword(String v) {
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

  String? _validateConfirmPassword(String v) {
    if (v.isEmpty) return 'Please re-enter your password';

    // Compare with the password stored in the provider.
    if (v != _password) return 'Passwords do not match';
    return null;
  }

  // --------------------------------- Actions ---------------------------------

  /// Validates every field. If all are valid, registers the account so its
  /// username/email become "taken" and returns true.
  bool submit() {
    _submitted = true;
    final isValid = _isValid;
    if (isValid) ExistingUsers.add(_username, _email);
    notifyListeners();
    return isValid;
  }

  /// Clears all data state and makes the screen rebuild empty fields.
  void reset() {
    _fullName = '';
    _username = '';
    _email = '';
    _password = '';
    _confirmPassword = '';
    _submitted = false;
    _formVersion++;
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
