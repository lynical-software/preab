import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:preab_example/src/auth/sign_in.dart';
import 'package:preab_example/src/home/home.dart';
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
