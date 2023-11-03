import 'package:Yize_Notes/components/routes.dart';
import 'package:Yize_Notes/components/show_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late final TextEditingController Email;
  late final TextEditingController Password;

  @override
  void initState() {
    Email = TextEditingController();
    Password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    Email.dispose();
    Password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            // Email textfield
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              controller: Email,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Password textfield
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: Password,
              decoration: const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              onPressed: () async {
                final email = Email.text;
                final password = Password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  final verifedEmail = user?.emailVerified ?? false;
                  if (verifedEmail) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      homeRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmail,
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                    await showErrorDialog(
                      context,
                      'Invalid email or password !',
                      'Invalid Login',
                    );
                  } else {
                     await showErrorDialog(
                      context,
                      'Error',
                      'Error: ${e.code}',
                    );
                  }
                } catch (e) {
                   await showErrorDialog(
                      context,
                      e.toString(),
                      'Error',
                    );
                }
              },
              child: Container(
                color: Colors.black,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      backgroundColor: Colors.black,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false,
                  );
                },
                child: const Text('Don\'t have an account? Register now!')),
          ],
        ),
      ),
    );
  }
}
