import 'package:pocketbase/pocketbase.dart';
import 'package:preab/src/model/preab_user.dart';

import '../constant/exception.dart';

class PreabClient {
  static PocketBase? _pocketBase;

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

  static void init<T>({
    required String url,
    required PreabUser user,
    required String token,
  }) {
    _pocketBase = PocketBase(url);
    _pocketBase!.authStore.save(token, user);
  }
}
