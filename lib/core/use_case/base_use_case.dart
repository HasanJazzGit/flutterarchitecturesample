import 'package:dartz/dartz.dart';
import '../failure/exceptions.dart';

/// Base use case interface
/// All use cases should implement this interface
/// Uses ErrorMsg (String) for error handling
abstract class UseCase<T, Params> {
  Future<Either<ErrorMsg, T>> call(Params params);
}


/// Use case with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<ErrorMsg, T>> call();
}

/// Use case with void return type
abstract class UseCaseVoid<Params> {
  Future<Either<ErrorMsg, void>> call(Params params);
}

/// Use case with void return type and no parameters
abstract class UseCaseVoidNoParams {
  Future<Either<ErrorMsg, void>> call();
}
