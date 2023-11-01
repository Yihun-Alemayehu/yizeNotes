import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Center(
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
                        try{
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                        } on FirebaseAuthException catch (e){
                          showDialog(
                            context: context, 
                            builder: ((context) => AlertDialog(
                              title: Text('Invalid Login'),
                              content: Text('Invalid email or password !'),
                            )));
                            // print(e.runtimeType);
                            // print(e.code);
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
                        ))
                  ],
                ),
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
