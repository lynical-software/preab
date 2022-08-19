enum PreabExceptionType { client, user }

class PreabException {
  final PreabExceptionType type;
  final String message;

  PreabException(this.type, this.message);

  @override
  String toString() {
    return "PreabException: ${type.name}: $message";
  }
}
