import 'package:firebase_auth/firebase_auth.dart';
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
                  final userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);

                  //print(userCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Weak Password'),
                        content:
                            Text('Password should be at least 6 characters'),
                      ),
                    );
                  } else if (e.code == 'email-already-in-use') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid email'),
                        content: Text(
                            'The email address is already in use by another account.'),
                      ),
                    );
                  } else if (e.code == 'invalid-email') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Invalid email'),
                        content:
                            Text('The email address you entered is not valid!'),
                      ),
                    );
                  }

                  print(e.code);
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
            const SizedBox(height: 30,),
            TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/login',(route) => false,);
              }, 
              child: const Text('Already have an account? Log In now!')),
          ],
        ),
      ),
    );
  }
}
