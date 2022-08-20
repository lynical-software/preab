import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:preab/preab.dart';
import 'package:shared_preferences/shared_preferences.dart';

const url = false ? "http://127.0.0.1:8090" : "https://pocketbase.lynical.com";

Future init() async {
  var spf = await SharedPreferences.getInstance();
  var token = spf.getString("token")!;
  var user = spf.getString("user")!;
  await PreabClient.init(
    url: url,
    token: token,
    user: UserModel.fromJson(jsonDecode(user)),
  );
}
