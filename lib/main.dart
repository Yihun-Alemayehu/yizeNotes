import 'package:Yize_Notes/components/routes.dart';
import 'package:Yize_Notes/pages/home.dart';
import 'package:Yize_Notes/pages/login_page.dart';
import 'package:Yize_Notes/pages/register_page.dart';
import 'package:Yize_Notes/pages/verify_email_page.dart';
import 'package:Yize_Notes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LogInPage(),
        registerRoute: (context) => const RegisterPage(),
        homeRoute: (context) => const Home(),
        verifyEmail: (context) => const VerifyEmail(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const Home();
              } else {
                return const VerifyEmail();
              }
            } else {
              return const RegisterPage();
            }
          default:
            return const Scaffold(
              body: Center(
                child: Text('Loading...'),
              ),
            );
        }
      },
    );
  }
}
