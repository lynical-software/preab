import 'dart:io';

import 'package:flutter/material.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/src/home.dart';

final url = Platform.isWindows ? 'http://127.0.0.1:8090' : 'http://10.0.2.2:8090';

class WindowUser implements PreabUser {
  @override
  String get id => "Kq47JnnOWlR4lGT";
}

class MobileUser implements PreabUser {
  @override
  String get id => "N6J4V94mVHALjmY";
}

void main() async {
  PreabClient.init(
    url: url,
    user: Platform.isWindows ? WindowUser() : MobileUser(),
    token: "",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Preab Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
