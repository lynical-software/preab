import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:preab_example/main.dart';
import 'package:preab_example/src/home.dart';
import 'package:preab_example/src/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sura_flutter/sura_flutter.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FutureManager<bool> splashManager = FutureManager();

  void onSplashScreen() async {
    var spf = await SharedPreferences.getInstance();
    if (spf.getString("token") != null) {
      var token = spf.getString("token")!;
      var user = spf.getString("user")!;
      pocketBase.authStore.save(token, UserModel.fromJson(jsonDecode(user)));
      SuraPageNavigator.pushAndRemove(context, const HomePage());
    } else {
      SuraPageNavigator.pushAndRemove(context, const SignInPage());
    }
  }

  @override
  void initState() {
    onSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
