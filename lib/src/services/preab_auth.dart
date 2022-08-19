import 'package:pocketbase/pocketbase.dart';
import 'package:preab/src/client/preab_client.dart';

import '../constant/exception.dart';

class PreabAuth {
  static String get me {
    var user = PreabClient.client.authStore.model as UserModel?;
    if (user == null) {
      throw PreabException(
        PreabExceptionType.user,
        "User haven't authenticated your user yet",
      );
    }
    return user.profile!.id;
  }
}
