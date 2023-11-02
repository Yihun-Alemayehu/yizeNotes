import 'package:Yize_Notes/components/routes.dart';
import 'package:Yize_Notes/pages/home.dart';
import 'package:Yize_Notes/pages/login_page.dart';
import 'package:Yize_Notes/pages/register_page.dart';
import 'package:Yize_Notes/pages/verify_email_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Yize_Notes/firebase_options.dart';


void main() {
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LogInPage(),
        registerRoute: (context) => const RegisterPage(),
        homeRoute: (context) => const Home(),
        verifyEmail:(context) => const VerifyEmail(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
               final user = FirebaseAuth.instance.currentUser;
               print(user);
               if(user != null) {
                 if (user.emailVerified) {
                    return const Home();
                  } else {
                      return const VerifyEmail();
                  }
               }else {
                  return const RegisterPage();
               }     
            default:
              return const Center(child: Text('Loading...'));
          }
        },
      );
  }
}

