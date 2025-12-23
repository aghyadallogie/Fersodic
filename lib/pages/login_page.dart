import 'package:fersodict/components/button.dart';
import 'package:fersodict/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_notifier.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  Future<void> login(BuildContext context, WidgetRef ref) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return;
    }

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
            SizedBox(height: 50),
            Text(
              'Welcome To PersoDict',
              style: TextStyle(
                fontSize: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 30),
            Textfield(hintText: 'Enter Email', controller: _emailController),
            SizedBox(height: 22),
            Textfield(
              hintText: 'Enter Password',
              isObscure: true,
              controller: _passwordController,
            ),
            SizedBox(height: 40),
            Button(text: 'Login', onPressed: () => login(context, ref)),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
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
