/// Domain-level errors. The data layer translates its technical exceptions
/// (HTTP, timeouts, invalid JSON) into one of these, so the presentation
/// layer never depends on transport details.
sealed class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure(super.message);
}
