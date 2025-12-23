import 'package:fersodict/components/button.dart';
import 'package:fersodict/components/textfield.dart';
import 'package:fersodict/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../providers/auth_repository_provider.dart';

class RegisterPage extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  Future<void> register(BuildContext context, WidgetRef ref) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      await ref
          .read(authRepositoryProvider)
          .registerAndLogin(email: email, plainPassword: password, name: null);

      await ref.read(authNotifierProvider.notifier).login(email, password);

      final authState = ref.read(authNotifierProvider);

      if (!context.mounted) return;

      authState.when(
        loading: () {},
        error: (_, __) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid credentials'))),
        data: (token) {
          print('token:::::::::::: $token');
          if (token != null) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      );
    } on EmailAlreadyRegistered {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email already registered')));
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.translate,
              size: 130,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            Text(
              'Welcome To PersoDict',
              style: TextStyle(
                fontSize: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            Textfield(hintText: 'Enter Email', controller: _emailController),
            const SizedBox(height: 22),
            Textfield(
              hintText: 'Enter Password',
              isObscure: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 22),
            Textfield(
              hintText: 'Confirm Password',
              isObscure: true,
              controller: _confirmPasswordController,
            ),
            const SizedBox(height: 40),
            Button(text: 'Register', onPressed: () => register(context, ref)),
            const SizedBox(height: 20),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
