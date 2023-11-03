import 'package:Yize_Notes/components/routes.dart';
import 'package:Yize_Notes/components/show_error.dart';
import 'package:Yize_Notes/services/auth/auth_exceptions.dart';
import 'package:Yize_Notes/services/auth/auth_service.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: const Text('Register page'),
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
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyEmail, (route) => false);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Password should be at least 6 characters',
                    'Weak Password',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'The email address is already in use by another account.',
                    'Invalid email',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'The email address you entered is not valid!',
                    'Invalid email',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Error: Registration failed',
                    'Error',
                  );
                }
              },
              child: Container(
                color: Colors.black,
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    'Register',
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
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Already have an account? Log In now!')),
          ],
        ),
      ),
    );
  }
}
