/// Either type for functional error handling
/// Left represents failure/error
/// Right represents success
sealed class Either<L, R> {
  const Either();

  /// Check if this is a Left (failure)
  bool get isLeft => this is Left<L, R>;

  /// Check if this is a Right (success)
  bool get isRight => this is Right<L, R>;

  /// Get Left value (throws if Right)
  L get left {
    if (this is Left<L, R>) {
      return (this as Left<L, R>).value;
    }
    throw Exception('Either is Right, not Left');
  }

  /// Get Right value (throws if Left)
  R get right {
    if (this is Right<L, R>) {
      return (this as Right<L, R>).value;
    }
    throw Exception('Either is Left, not Right');
  }

  /// Fold: apply function based on Left or Right
  T fold<T>(T Function(L left) onLeft, T Function(R right) onRight) {
    if (this is Left<L, R>) {
      return onLeft((this as Left<L, R>).value);
    } else {
      return onRight((this as Right<L, R>).value);
    }
  }

  /// Map over Right value
  Either<L, T> map<T>(T Function(R right) mapper) {
    if (this is Left<L, R>) {
      return Left<L, T>((this as Left<L, R>).value);
    } else {
      return Right<L, T>(mapper((this as Right<L, R>).value));
    }
  }

  /// Map over Left value
  Either<T, R> mapLeft<T>(T Function(L left) mapper) {
    if (this is Left<L, R>) {
      return Left<T, R>(mapper((this as Left<L, R>).value));
    } else {
      return Right<T, R>((this as Right<L, R>).value);
    }
  }

  /// FlatMap: chain Either operations
  Either<L, T> flatMap<T>(Either<L, T> Function(R right) mapper) {
    if (this is Left<L, R>) {
      return Left<L, T>((this as Left<L, R>).value);
    } else {
      return mapper((this as Right<L, R>).value);
    }
  }
}

/// Left represents failure/error
class Left<L, R> extends Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  String toString() => 'Left($value)';
}

/// Right represents success
class Right<L, R> extends Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  String toString() => 'Right($value)';
}

/// Helper functions
extension EitherExtension<L, R> on Either<L, R> {
  /// Get value or default if Left
  R getOrElse(R defaultValue) {
    return fold((_) => defaultValue, (right) => right);
  }

  /// Get value or null if Left
  R? getOrNull() {
    return fold((_) => null, (right) => right);
  }

  /// Execute function if Right
  Either<L, R> onRight(void Function(R right) action) {
    if (isRight) {
      action(right);
    }
    return this;
  }

  /// Execute function if Left
  Either<L, R> onLeft(void Function(L left) action) {
    if (isLeft) {
      action(left);
    }
    return this;
  }
}

