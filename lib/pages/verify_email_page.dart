import 'package:Yize_Notes/components/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
          child: Column(
            children: [
              const Text('We\'ve sent you a verification email, please open your email inbox and click the link to verify your account!'),
              const SizedBox(height: 40,),
              const Text('If you haven\'t recieved a verification email yet, Please press the button below !'),
              TextButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    await Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: const Text('Send email verification')),
            ],
          ),
        ),
      ),
    );
  }
}