import 'package:flutter/material.dart';
import 'package:future_manager/future_manager.dart';
import 'package:sura_flutter/sura_flutter.dart';

import 'src/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureManagerProvider(
      onFutureManagerError: (err, context) {
        errorLog(err.stackTrace);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Preab Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreenPage(),
      ),
    );
  }
}
