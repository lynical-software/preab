import 'package:preab/preab.dart';
import 'package:preab/src/constant/collection_name.dart';

class PreabProfileService {
  PreabProfileService._privateConstructor();

  static final PreabProfileService instance = PreabProfileService._privateConstructor();

  Future<List<PreabProfile>> searchUser(String keyword) async {
    final result = await PreabClient.client.records.getList(
      profileCollection,
      filter: "(name ~ '$keyword') || (id ~ '$keyword')",
    );
    return result.items.map((e) => PreabProfile.fromJson(e.toJson())).toList();
  }
}
