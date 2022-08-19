import 'package:preab/src/client/preab_client.dart';

import '../constant/exception.dart';
import '../model/preab_user.dart';

class PreabAuth {
  static PreabUser get me {
    var user = PreabClient.client.authStore.model as PreabUser?;
    if (user == null) {
      throw PreabException(
        PreabExceptionType.user,
        "User haven't authenticated your user yet",
      );
    }
    return user;
  }
}
