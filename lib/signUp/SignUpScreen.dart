import 'package:flutter/material.dart';
import 'package:flutter_play_ground/signUp/SignUpProvider.dart';
import 'package:provider/provider.dart';

/// No GlobalKey and no Form: SignUpProvider owns the values, the errors and
/// the submit/reset logic, so this screen is just a StatelessWidget that
/// draws whatever the provider says.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  // --------------------------------- Submit ----------------------------------

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    final provider = context.read<SignUpProvider>();

    // submit() validates EVERY field (what FormState.validate() used to do).
    if (!provider.submit()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Capture values now: the dialog builds after the provider is reset below.
    final fullName = provider.fullName;
    final username = provider.username;
    final email = provider.email;

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Account created'),
        content: Text(
          'Welcome, $fullName!\n\n'
          'Username: $username\n'
          'Email: $email\n\n'
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

    provider.reset();
  }

  // ---------------------------------- UI -------------------------------------

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignUpProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            // When reset() bumps formVersion this key changes, so Flutter
            // throws away the old TextFields (and their text) and builds new,
            // empty ones. This replaces FormState.reset().
            key: ValueKey(provider.formVersion),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: const OutlineInputBorder(),
                  errorText: provider.fullNameError,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onChanged: provider.setFullName,
              ),
              const SizedBox(height: 16),

              // Username
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.alternate_email),
                  border: const OutlineInputBorder(),
                  errorText: provider.usernameError,
                ),
                textInputAction: TextInputAction.next,
                onChanged: provider.setUsername,
              ),
              const SizedBox(height: 16),

              // Email
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                  errorText: provider.emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: provider.setEmail,
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                obscureText: provider.obscurePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  errorText: provider.passwordError,
                  errorMaxLines: 6,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: provider.toggleObscurePassword,
                  ),
                ),
                // Store the password in the provider; the rebuild that
                // follows refreshes the confirm field's error below.
                onChanged: provider.setPassword,
              ),
              const SizedBox(height: 16),

              // Re-enter Password
              TextField(
                obscureText: provider.obscureConfirm,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(context),
                decoration: InputDecoration(
                  labelText: 'Re-enter Password',
                  prefixIcon: const Icon(Icons.lock_reset),
                  border: const OutlineInputBorder(),
                  errorText: provider.confirmPasswordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      provider.obscureConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: provider.toggleObscureConfirm,
                  ),
                ),
                onChanged: provider.setConfirmPassword,
              ),
              const SizedBox(height: 28),

              FilledButton(
                onPressed: () => _submit(context),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: provider.reset,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
