import 'package:flutter/material.dart';

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
      (u) => u['username']!.toLowerCase() == username.trim().toLowerCase());

  static bool isEmailTaken(String email) => users
      .any((u) => u['email']!.toLowerCase() == email.trim().toLowerCase());

  static void add(String username, String email) =>
      users.add({'username': username.trim(), 'email': email.trim()});
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ---------------------------------------------------------------------------
  // GlobalKey #1: GlobalKey<FormState>
  // Gives us access to the Form's State from outside the Form's build method.
  // With it we can call validate(), save() and reset() on ALL fields at once.
  // ---------------------------------------------------------------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ---------------------------------------------------------------------------
  // GlobalKey #2 & #3: GlobalKey<FormFieldState<String>>
  // Gives us access to ONE specific field's state (its current value,
  // validate(), reset()...). We use it for cross-field validation:
  // "Re-enter Password" reads the Password field's value through this key.
  // ---------------------------------------------------------------------------
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _confirmPasswordFieldKey =
      GlobalKey<FormFieldState<String>>();

  // Values filled in by onSaved when _formKey.currentState!.save() is called.
  String _fullName = '';
  String _username = '';
  String _email = '';

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Show errors only after the first submit attempt, then live while typing.
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  // ------------------------------- Validators --------------------------------

  String? _validateFullName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name must be at least 3 characters';
    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(v)) {
      return 'Full name can only contain letters and spaces';
    }
    return null;
  }

  String? _validateUsername(String? value) {
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

  String? _validateEmail(String? value) {
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

  String? _validatePassword(String? value) {
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

  String? _validateConfirmPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Please re-enter your password';

    // Read the OTHER field's value using its GlobalKey.
    final password = _passwordFieldKey.currentState?.value ?? '';
    if (v != password) return 'Passwords do not match';
    return null;
  }

  // --------------------------------- Submit ----------------------------------

  void _submit() {
    FocusScope.of(context).unfocus();

    // validate() runs the validator of EVERY TextFormField inside the Form.
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      setState(() => _autovalidateMode = AutovalidateMode.onUserInteraction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // save() calls onSaved of every field.
    _formKey.currentState!.save();

    ExistingUsers.add(_username, _email);

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Account created'),
        content: Text(
          'Welcome, $_fullName!\n\n'
          'Username: $_username\n'
          'Email: $_email\n\n'
          'Try signing up again with the same username/email — '
          'it will now be reported as taken.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // reset() clears every field back to its initial value.
    _formKey.currentState!.reset();
    setState(() => _autovalidateMode = AutovalidateMode.disabled);
  }

  // ---------------------------------- UI -------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // <-- attach the GlobalKey<FormState>
            autovalidateMode: _autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create your account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Full Name
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: _validateFullName,
                  onSaved: (v) => _fullName = v!.trim(),
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                    helperText: 'Taken: rashid, ali_khan, sara123, john_doe',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateUsername,
                  onSaved: (v) => _username = v!.trim(),
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                  onSaved: (v) => _email = v!.trim(),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  key: _passwordFieldKey, // <-- GlobalKey<FormFieldState>
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    errorMaxLines: 6,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: _validatePassword,
                  onChanged: (_) {
                    // When the password changes, re-check the confirm field
                    // (only if the user already typed something there).
                    final confirm = _confirmPasswordFieldKey.currentState;
                    if (confirm != null && (confirm.value ?? '').isNotEmpty) {
                      confirm.validate();
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Re-enter Password
                TextFormField(
                  key: _confirmPasswordFieldKey,
                  obscureText: _obscureConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 28),

                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    _formKey.currentState!.reset();
                    setState(
                        () => _autovalidateMode = AutovalidateMode.disabled);
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
