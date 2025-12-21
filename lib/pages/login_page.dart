import 'package:fersodict/components/button.dart';
import 'package:fersodict/components/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login() {
    // Implement login logic here
    String email = _emailController.text;
    String password = _passwordController.text;
    print('Email: $email, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
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
            Button(text: 'Login', onPressed: login),
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
