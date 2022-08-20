import 'package:flutter/material.dart';
import 'package:preab/preab.dart';

class ProfileAvatar extends StatelessWidget {
  final PreabProfile user;
  const ProfileAvatar({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> split = user.id.split(" ");
    final String first = split.first;
    final String last = split.length > 1 ? split.last : " ";
    return CircleAvatar(
      child: Text(
        "${first[0].toUpperCase()}${last[0].toUpperCase()}".trim(),
      ),
    );
  }
}
