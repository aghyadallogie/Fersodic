import 'package:fersodict/components/button.dart';
import 'package:fersodict/components/textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register() {
    // Implement register logic here
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
            SizedBox(height: 22),
            Textfield(
              hintText: 'Confirm Password',
              controller: _confirmPasswordController,
            ),
            SizedBox(height: 40),
            Button(text: 'Register', onPressed: register),
            SizedBox(height: 20),
            SizedBox(height: 80),
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
