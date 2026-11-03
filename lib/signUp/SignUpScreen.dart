import 'package:flutter/material.dart';
import 'package:flutter_play_ground/signUp/SignUpProvider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // ---------------------------------------------------------------------------
  // GlobalKey<FormState>
  // Gives us access to the Form's State from outside the Form's build method.
  // With it we can call validate(), save() and reset() on ALL fields at once.
  //
  // The Password / Re-enter Password fields do NOT use GlobalKeys any more:
  // their values are kept in SignUpProvider, which the confirm validator
  // reads directly.
  // ---------------------------------------------------------------------------
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // --------------------------------- Submit ----------------------------------

  void _submit() {
    FocusScope.of(context).unfocus();
    final provider = context.read<SignUpProvider>();

    // validate() runs the validator of EVERY TextFormField inside the Form.
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      provider.enableAutovalidate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // save() calls onSaved of every field, which stores values in the provider.
    _formKey.currentState!.save();
    provider.register();

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

    _clear();
  }

  void _clear() {
    // reset() clears every field back to its initial value.
    _formKey.currentState!.reset();
    context.read<SignUpProvider>().reset();
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
          child: Form(
            key: _formKey, // <-- attach the GlobalKey<FormState>
            autovalidateMode: provider.autovalidateMode,
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
                  validator: provider.validateFullName,
                  onSaved: (v) => provider.setFullName(v!),
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: provider.validateUsername,
                  onSaved: (v) => provider.setUsername(v!),
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
                  validator: provider.validateEmail,
                  onSaved: (v) => provider.setEmail(v!),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  obscureText: provider.obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
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
                  validator: provider.validatePassword,
                  // Store the password in the provider; the rebuild that
                  // follows re-validates the confirm field below.
                  onChanged: provider.setPassword,
                ),
                const SizedBox(height: 16),

                // Re-enter Password
                TextFormField(
                  obscureText: provider.obscureConfirm,
                  textInputAction: TextInputAction.done,
                  // Once the user has typed here, re-validate on every rebuild
                  // (including when the password above changes).
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Re-enter Password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        provider.obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: provider.toggleObscureConfirm,
                    ),
                  ),
                  validator: provider.validateConfirmPassword,
                  onChanged: provider.setConfirmPassword,
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
                OutlinedButton(onPressed: _clear, child: const Text('Clear')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
