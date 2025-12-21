import 'package:fersodict/pages/login_page.dart';
import 'package:fersodict/pages/register_page.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showLoginPage = true;

  void toggleAuthenticationPages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: toggleAuthenticationPages);
    } else {
      return RegisterPage(onTap: toggleAuthenticationPages);
    }
  }
}
