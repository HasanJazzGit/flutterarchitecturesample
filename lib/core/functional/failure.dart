import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Server failure (API errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'ServerFailure: $message (code: $code)';
}

/// Network failure (connection errors)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });

  @override
  String toString() => 'NetworkFailure: $message';
}

/// Cache failure (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });

  @override
  String toString() => 'CacheFailure: $message';
}

/// Validation failure (input validation errors)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });

  @override
  String toString() => 'ValidationFailure: $message';
}

/// Authentication failure (auth errors)
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });

  @override
  String toString() => 'AuthFailure: $message (code: $code)';
}

/// Unknown failure (unexpected errors)
class UnknownFailure extends Failure {
  final Object? error;
  final StackTrace? stackTrace;

  const UnknownFailure({
    required super.message,
    this.error,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, error, stackTrace];

  @override
  String toString() => 'UnknownFailure: $message';
}

