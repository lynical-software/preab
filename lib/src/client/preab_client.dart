import 'package:pocketbase/pocketbase.dart';

import '../constant/exception.dart';

class PreabClient {
  static PocketBase? _pocketBase;

  static String? _userId;

  static PocketBase get client {
    assert(_pocketBase != null);
    if (_pocketBase == null) {
      throw PreabException(
        PreabExceptionType.client,
        "Please call PreabClient.init to initialize PocketBase",
      );
    }
    return _pocketBase!;
  }

  static String get userId {
    assert(_userId != null);
    if (_userId == null) {
      throw PreabException(
        PreabExceptionType.user,
        "Please call PreabClient.init to initialize PocketBase",
      );
    }
    return _userId!;
  }

  static Future<void> init<T>({
    required String url,
    required UserModel user,
    required String token,
  }) async {
    try {
      _pocketBase = PocketBase(url);
      if (user.profile == null) {
        throw PreabException(PreabExceptionType.user, "profile not found");
      }
      await _pocketBase!.records.getOne("profiles", user.profile?.id ?? "");
      _userId = user.profile!.id;
      _pocketBase!.authStore.save(token, user);
    } on ClientException catch (e) {
      throw e.response['message'];
    }
  }
}
