/// Technical exceptions thrown by data sources. The repository converts
/// them into domain `Failure`s.
sealed class DataException implements Exception {
  final String message;

  const DataException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends DataException {
  const NetworkException(super.message);
}

class ServerException extends DataException {
  final int? statusCode;

  const ServerException(super.message, {this.statusCode});
}

class ParsingException extends DataException {
  const ParsingException(super.message);
}
