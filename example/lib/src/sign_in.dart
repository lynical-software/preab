import 'package:flutter/material.dart';
import 'package:sura_flutter/sura_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();

  @override
  void dispose() {
    emailTC.dispose();
    passwordTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailTC,
                decoration: const InputDecoration(labelText: "Email,"),
              ),
              const SpaceY(24),
              TextField(
                controller: passwordTC,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              SuraAsyncButton(
                onPressed: () {},
                child: const Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
