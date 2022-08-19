import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:preab/preab.dart';
import 'package:preab_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
