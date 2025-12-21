# 🔄 Functional Programming Guide

Complete guide for using functional programming utilities (Either, Failure) in Flutter - when, why, and how to use them.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What is Either?](#what-is-either)
3. [Why Use Either?](#why-use-either)
4. [When to Use Either](#when-to-use-either)
5. [Either Usage](#either-usage)
6. [Failure Classes](#failure-classes)
7. [Complete Examples](#complete-examples)
8. [Best Practices](#best-practices)
9. [Common Patterns](#common-patterns)

---

## 📖 Overview

**Functional Programming** provides a type-safe way to handle errors and operations that can succeed or fail. Instead of throwing exceptions or returning null, we use `Either<Error, Success>`.

### Benefits
- ✅ Type-safe error handling
- ✅ No exceptions (explicit error handling)
- ✅ Compile-time checked
- ✅ Composable operations
- ✅ Better code readability

---

## 🎯 What is Either?

`Either<L, R>` is a type that represents **one of two possible values**:
- **Left (L)** - Represents failure/error
- **Right (R)** - Represents success/value

### Visual Representation

```
Either<Error, Data>
    │
    ├─→ Left(Error)   ❌ Failure
    │
    └─→ Right(Data)   ✅ Success
```

### Basic Structure

```dart
sealed class Either<L, R> {
  // Left = Error/Failure
  // Right = Success/Value
}

class Left<L, R> extends Either<L, R> {
  final L value;  // Error value
}

class Right<L, R> extends Either<L, R> {
  final R value;  // Success value
}
```

---

## 💡 Why Use Either?

### Problem with Traditional Error Handling

**❌ Using Exceptions:**
```dart
// Problem: Exceptions can be missed, not type-safe
Future<User> getUser(int id) async {
  if (id < 0) {
    throw Exception('Invalid ID');  // Can be missed
  }
  return await api.getUser(id);
}

// Usage: Must remember try-catch
try {
  final user = await getUser(-1);
} catch (e) {
  // Easy to forget, not enforced
}
```

**❌ Using Null:**
```dart
// Problem: Null doesn't tell you WHY it failed
Future<User?> getUser(int id) async {
  if (id < 0) return null;  // Why null? Unknown
  return await api.getUser(id);
}

// Usage: No error information
final user = await getUser(-1);
if (user == null) {
  // Why is it null? No information
}
```

### Solution with Either

**✅ Using Either:**
```dart
// Solution: Type-safe, explicit error handling
Future<Either<String, User>> getUser(int id) async {
  if (id < 0) {
    return Left('Invalid ID: $id');  // Explicit error
  }
  try {
    final user = await api.getUser(id);
    return Right(user);  // Explicit success
  } catch (e) {
    return Left('Failed to get user: $e');  // Explicit error
  }
}

// Usage: Must handle both cases
final result = await getUser(-1);
result.fold(
  (error) => print('Error: $error'),      // Must handle error
  (user) => print('User: ${user.name}'),   // Must handle success
);
```

### Benefits

1. **Type Safety** - Compiler forces you to handle errors
2. **Explicit** - Clear what can fail and how
3. **No Exceptions** - Errors are values, not thrown
4. **Composable** - Chain operations easily
5. **Testable** - Easy to test success and failure cases

---

## ✅ When to Use Either

### ✅ Use Either When:

1. **Repository Methods**
   - API calls that can fail
   - Database operations
   - File operations

2. **Use Cases**
   - Business logic that can fail
   - Validation operations
   - Data transformations

3. **Operations with Multiple Outcomes**
   - Success or failure
   - Valid or invalid
   - Found or not found

### ❌ Don't Use Either When:

1. **Simple Operations**
   - Pure calculations (use return value)
   - Simple getters (use return value)

2. **UI Operations**
   - Widget building (use regular return)
   - Event handlers (use void)

3. **Synchronous Operations**
   - Simple validations (use bool)
   - Simple checks (use bool)

---

## 🔍 Either Usage

### Creating Either Values

```dart
// Success (Right)
final success = Right<String, int>(42);
final success2 = Right('User data');

// Failure (Left)
final failure = Left<String, int>('Error message');
final failure2 = Left('Failed to load data');
```

### Pattern 1: Using `fold()` (Recommended)

`fold()` forces you to handle both success and failure cases.

```dart
final result = await repository.getData();

result.fold(
  // Left: Handle error
  (error) {
    print('Error: $error');
    emit(state.copyWith(errorMessage: error));
  },
  // Right: Handle success
  (data) {
    print('Data: $data');
    emit(state.copyWith(data: data));
  },
);
```

### Pattern 2: Check Type First

```dart
final result = await repository.getData();

if (result.isLeft) {
  // Handle error
  final error = result.left;
  print('Error: $error');
} else {
  // Handle success
  final data = result.right;
  print('Data: $data');
}
```

### Pattern 3: Using Extensions

```dart
final result = await repository.getData();

// Get value or default
final data = result.getOrElse([]);  // Returns [] if Left

// Get value or null
final data = result.getOrNull();  // Returns null if Left

// Execute if success
result.onRight((data) {
  print('Success: $data');
});

// Execute if error
result.onLeft((error) {
  print('Error: $error');
});
```

### Pattern 4: Transform with `map()`

```dart
final result = await repository.getUser(1);

// Transform success value
final userName = result.map((user) => user.name);
// Either<String, String> - transforms Right value

// Transform error value
final errorMessage = result.mapLeft((error) => 'Error: $error');
// Either<String, User> - transforms Left value
```

### Pattern 5: Chain Operations with `flatMap()`

```dart
Future<Either<String, User>> getUser(int id) async {
  // ... get user
}

Future<Either<String, Profile>> getProfile(User user) async {
  // ... get profile
}

// Chain operations
final result = await getUser(1)
  .flatMap((user) => getProfile(user));

// If getUser fails, getProfile is never called
// If getUser succeeds, getProfile is called with user
```

---

## 🚨 Failure Classes

### What are Failure Classes?

Failure classes represent **typed errors** instead of generic strings. They provide more information about what went wrong.

### Available Failure Types

```dart
// Server failure (API errors)
ServerFailure(message: 'API error', code: 500)

// Network failure (connection errors)
NetworkFailure(message: 'No internet connection')

// Cache failure (local storage errors)
CacheFailure(message: 'Failed to save to cache')

// Validation failure (input validation errors)
ValidationFailure(message: 'Email is invalid')

// Authentication failure (auth errors)
AuthFailure(message: 'Invalid credentials', code: 401)

// Unknown failure (unexpected errors)
UnknownFailure(message: 'Unexpected error', error: exception, stackTrace: stack)
```

### When to Use Failure Classes

**✅ Use Failure Classes When:**
- You need specific error types
- Different error handling per error type
- Error categorization needed

**❌ Use String (ErrorMsg) When:**
- Simple error messages are enough
- No need for error categorization
- Quick prototyping

### Using Failure Classes

```dart
// Repository with Failure
Future<Either<Failure, User>> getUser(int id) async {
  try {
    final user = await api.getUser(id);
    return Right(user);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Left(NetworkFailure(message: 'Connection timeout'));
    }
    return Left(ServerFailure(message: e.message ?? 'Server error', code: e.response?.statusCode));
  } catch (e) {
    return Left(UnknownFailure(message: 'Unexpected error', error: e));
  }
}

// Usage with specific error handling
final result = await repository.getUser(1);

result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      // Handle network error specifically
      showNetworkError();
    } else if (failure is ServerFailure) {
      // Handle server error specifically
      showServerError(failure.code);
    } else {
      // Handle other errors
      showGenericError(failure.message);
    }
  },
  (user) {
    // Handle success
    showUser(user);
  },
);
```

---

## 📚 Complete Examples

### Example 1: Repository with Either

**Repository Interface:**
```dart
abstract class UserRepository {
  Future<Either<ErrorMsg, User>> getUser(int id);
  Future<Either<ErrorMsg, List<User>>> getAllUsers();
  Future<Either<ErrorMsg, User>> createUser(User user);
}
```

**Repository Implementation:**
```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  @override
  Future<Either<ErrorMsg, User>> getUser(int id) async {
    try {
      // Try remote first
      final user = await remoteDataSource.getUser(id);
      
      // Save to local
      await localDataSource.saveUser(user);
      
      return Right(user);
    } catch (e) {
      // Fallback to local
      try {
        final user = await localDataSource.getUser(id);
        return Right(user);
      } catch (localError) {
        return Left('Failed to get user: ${localError.toString()}');
      }
    }
  }

  @override
  Future<Either<ErrorMsg, List<User>>> getAllUsers() async {
    try {
      final users = await remoteDataSource.getAllUsers();
      await localDataSource.saveUsers(users);
      return Right(users);
    } catch (e) {
      return Left('Failed to get users: ${e.toString()}');
    }
  }

  @override
  Future<Either<ErrorMsg, User>> createUser(User user) async {
    try {
      final createdUser = await remoteDataSource.createUser(user);
      await localDataSource.saveUser(createdUser);
      return Right(createdUser);
    } catch (e) {
      return Left('Failed to create user: ${e.toString()}');
    }
  }
}
```

### Example 2: Use Case with Either

**Use Case:**
```dart
class GetUserUseCase implements UseCase<User, GetUserParams> {
  final UserRepository repository;

  GetUserUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, User>> call(GetUserParams params) async {
    // Validate params
    if (params.id <= 0) {
      return Left('Invalid user ID: ${params.id}');
    }

    // Call repository
    return await repository.getUser(params.id);
  }
}

class GetUserParams {
  final int id;
  GetUserParams({required this.id});
}
```

### Example 3: Cubit with Either

**Cubit:**
```dart
class UserCubit extends Cubit<UserState> {
  final GetUserUseCase getUserUseCase;

  UserCubit({required this.getUserUseCase}) : super(UserState.initial());

  Future<void> loadUser(int id) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await getUserUseCase.call(GetUserParams(id: id));

    result.fold(
      // Left: Error
      (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: error,
        ));
      },
      // Right: Success
      (user) {
        emit(state.copyWith(
          isLoading: false,
          user: user,
          errorMessage: null,
        ));
      },
    );
  }
}
```

### Example 4: Chaining Operations

```dart
// Chain multiple operations
Future<Either<ErrorMsg, Profile>> getUserProfile(int userId) async {
  // Step 1: Get user
  final userResult = await userRepository.getUser(userId);
  
  return userResult.flatMap((user) async {
    // Step 2: Get profile (only if user exists)
    return await profileRepository.getProfile(user.id);
  });
}

// Usage
final result = await getUserProfile(1);

result.fold(
  (error) => print('Error: $error'),
  (profile) => print('Profile: ${profile.name}'),
);
```

### Example 5: Transform Data

```dart
// Transform user to user name
Future<Either<ErrorMsg, String>> getUserName(int id) async {
  final result = await userRepository.getUser(id);
  
  // Transform User to String (user name)
  return result.map((user) => user.name);
}

// Usage
final nameResult = await getUserName(1);

nameResult.fold(
  (error) => print('Error: $error'),
  (name) => print('Name: $name'),
);
```

---

## ✅ Best Practices

### 1. **Always Use `fold()` for Handling**

```dart
// ✅ Good - Handles both cases
result.fold(
  (error) => handleError(error),
  (data) => handleSuccess(data),
);

// ❌ Bad - Might miss error case
if (result.isRight) {
  handleSuccess(result.right);
}
```

### 2. **Use Left for Errors, Right for Success**

```dart
// ✅ Good - Clear convention
return Left('Error message');   // Error
return Right(data);             // Success

// ❌ Bad - Confusing
return Right('Error message');  // Wrong!
return Left(data);              // Wrong!
```

### 3. **Return Either from Repositories and Use Cases**

```dart
// ✅ Good - Repository returns Either
Future<Either<ErrorMsg, User>> getUser(int id);

// ❌ Bad - Throws exceptions
Future<User> getUser(int id) {
  throw Exception('Error');  // Not type-safe
}
```

### 4. **Use ErrorMsg for Simple Errors**

```dart
// ✅ Good - Simple string errors
Future<Either<ErrorMsg, User>> getUser(int id);
// ErrorMsg = String

// ✅ Also Good - Typed failures for complex cases
Future<Either<Failure, User>> getUser(int id);
// Failure = ServerFailure, NetworkFailure, etc.
```

### 5. **Handle Errors in Cubit/Bloc**

```dart
// ✅ Good - Handle in Cubit
result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (data) => emit(state.copyWith(data: data)),
);

// ❌ Bad - Let error propagate
final data = result.right;  // Throws if Left
```

### 6. **Chain Operations with `flatMap()`**

```dart
// ✅ Good - Chain operations
final result = await getUser(1)
  .flatMap((user) => getProfile(user.id))
  .flatMap((profile) => getSettings(profile.id));

// ❌ Bad - Nested if-else
final userResult = await getUser(1);
if (userResult.isRight) {
  final profileResult = await getProfile(userResult.right.id);
  if (profileResult.isRight) {
    // ... nested
  }
}
```

---

## 🔄 Common Patterns

### Pattern 1: Repository Pattern

```dart
abstract class Repository {
  Future<Either<ErrorMsg, Data>> getData();
}

class RepositoryImpl implements Repository {
  @override
  Future<Either<ErrorMsg, Data>> getData() async {
    try {
      final data = await remoteDataSource.getData();
      return Right(data);
    } catch (e) {
      return Left('Failed to get data: ${e.toString()}');
    }
  }
}
```

### Pattern 2: Use Case Pattern

```dart
class GetDataUseCase implements UseCase<Data, NoParams> {
  final Repository repository;

  GetDataUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, Data>> call(NoParams params) async {
    return await repository.getData();
  }
}
```

### Pattern 3: Cubit Pattern

```dart
class DataCubit extends Cubit<DataState> {
  final GetDataUseCase getDataUseCase;

  DataCubit({required this.getDataUseCase}) : super(DataState.initial());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true));

    final result = await getDataUseCase.call();

    result.fold(
      (error) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error,
      )),
      (data) => emit(state.copyWith(
        isLoading: false,
        data: data,
      )),
    );
  }
}
```

### Pattern 4: Transform Pattern

```dart
// Transform Entity to Model
Future<Either<ErrorMsg, UserModel>> getUserModel(int id) async {
  final result = await userRepository.getUser(id);
  
  return result.map((entity) => UserMapper.toModel(entity));
}
```

### Pattern 5: Validation Pattern

```dart
Future<Either<ErrorMsg, User>> createUser(String email, String password) async {
  // Validate email
  if (!isValidEmail(email)) {
    return Left('Invalid email format');
  }

  // Validate password
  if (password.length < 8) {
    return Left('Password must be at least 8 characters');
  }

  // Create user
  try {
    final user = await repository.createUser(email, password);
    return Right(user);
  } catch (e) {
    return Left('Failed to create user: ${e.toString()}');
  }
}
```

---

## 📋 Quick Reference

### Either Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `fold()` | Handle both Left and Right | `result.fold((e) => error, (d) => data)` |
| `map()` | Transform Right value | `result.map((d) => d.name)` |
| `mapLeft()` | Transform Left value | `result.mapLeft((e) => 'Error: $e')` |
| `flatMap()` | Chain Either operations | `result.flatMap((d) => getMore(d))` |
| `isLeft` | Check if Left | `if (result.isLeft) ...` |
| `isRight` | Check if Right | `if (result.isRight) ...` |
| `left` | Get Left value | `final error = result.left` |
| `right` | Get Right value | `final data = result.right` |
| `getOrElse()` | Get value or default | `result.getOrElse([])` |
| `getOrNull()` | Get value or null | `result.getOrNull()` |
| `onRight()` | Execute if Right | `result.onRight((d) => print(d))` |
| `onLeft()` | Execute if Left | `result.onLeft((e) => print(e))` |

### Failure Types

| Type | When to Use |
|------|-------------|
| `ServerFailure` | API/server errors |
| `NetworkFailure` | Connection issues |
| `CacheFailure` | Local storage errors |
| `ValidationFailure` | Input validation errors |
| `AuthFailure` | Authentication errors |
| `UnknownFailure` | Unexpected errors |

### File Locations

- **Either**: `lib/core/functional/either.dart`
- **Failure**: `lib/core/functional/failure.dart`
- **ErrorMsg**: `lib/core/failure/exceptions.dart`
- **Export**: `lib/core/functional/functional_export.dart`

---

## ✅ Checklist

When using Either:

- [ ] Return `Either<ErrorMsg, T>` from repositories
- [ ] Return `Either<ErrorMsg, T>` from use cases
- [ ] Use `fold()` to handle both cases
- [ ] Use `Left()` for errors
- [ ] Use `Right()` for success
- [ ] Handle errors in Cubit/Bloc
- [ ] Use `flatMap()` for chaining operations
- [ ] Use `map()` for transformations

---

## 🎯 Summary

1. ✅ **Either** = Type-safe error handling (Left = Error, Right = Success)
2. ✅ **Use in** Repositories, Use Cases, operations that can fail
3. ✅ **Always use** `fold()` to handle both cases
4. ✅ **Chain operations** with `flatMap()`
5. ✅ **Transform data** with `map()`
6. ✅ **Use Failure classes** for typed errors when needed
7. ✅ **Use ErrorMsg (String)** for simple error messages

---

**Why Either?** It makes error handling **explicit, type-safe, and composable** - no more forgotten try-catch blocks or null checks!
