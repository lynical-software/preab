import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:preab_example/main.dart';
import 'package:preab_example/src/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                onPressed: () async {
                  try {
                    var pocketBase = PocketBase(url);
                    UserAuth auth = await pocketBase.users.authViaEmail(
                      emailTC.text.trim(),
                      passwordTC.text.trim(),
                    );
                    var spf = await SharedPreferences.getInstance();
                    spf.setString("token", auth.token);
                    spf.setString("user", jsonEncode(auth.user!.toJson()));
                    SuraPageNavigator.pushAndRemove(
                      context,
                      const HomePage(),
                    );
                  } on ClientException catch (e) {
                    showSuraSimpleDialog(context, e.response['message']);
                  }
                },
                child: const Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
