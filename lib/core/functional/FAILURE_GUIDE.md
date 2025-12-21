# 🚨 Failure Classes Guide

Complete guide for using failure classes in Flutter - when, why, and how to use typed errors.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What are Failure Classes?](#what-are-failure-classes)
3. [Why Use Failure Classes?](#why-use-failure-classes)
4. [Failure Types](#failure-types)
5. [When to Use Each Type](#when-to-use-each-type)
6. [Using Failures with Either](#using-failures-with-either)
7. [Complete Examples](#complete-examples)
8. [Failure vs ErrorMsg](#failure-vs-errormsg)
9. [Best Practices](#best-practices)
10. [Common Patterns](#common-patterns)

---

## 📖 Overview

**Failure Classes** are typed error classes that represent different categories of errors in your application. They provide more information and better error handling than simple strings.

### Benefits
- ✅ **Type Safety** - Compile-time checked error types
- ✅ **Categorization** - Group errors by type
- ✅ **Specific Handling** - Different handling per error type
- ✅ **More Information** - Additional context (code, stack trace)
- ✅ **Better Debugging** - Clear error types in logs

### File Location

```
lib/core/functional/
└── failure.dart    # Failure classes
```

---

## 🎯 What are Failure Classes?

**Failure Classes** are typed error classes that extend a base `Failure` class. They categorize errors into specific types (Server, Network, Cache, etc.) instead of using generic strings.

### Base Failure Class

```dart
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });
}
```

### Failure Hierarchy

```
Failure (abstract base class)
├── ServerFailure      (API/server errors)
├── NetworkFailure     (Connection errors)
├── CacheFailure       (Local storage errors)
├── ValidationFailure  (Input validation errors)
├── AuthFailure        (Authentication errors)
└── UnknownFailure     (Unexpected errors)
```

---

## 💡 Why Use Failure Classes?

### Problem with String Errors

**❌ Generic String Errors:**
```dart
// Problem: No way to distinguish error types
Future<Either<String, User>> getUser(int id) async {
  try {
    return Right(await api.getUser(id));
  } catch (e) {
    return Left('Error: ${e.toString()}');  // Generic string
  }
}

// Usage: Can't handle different error types specifically
result.fold(
  (error) {
    // How do we know if it's network, server, or validation error?
    showError(error);  // Same handling for all errors
  },
  (user) => showUser(user),
);
```

**❌ No Error Categorization:**
```dart
// All errors treated the same
if (error.contains('network')) {  // Fragile string matching
  // Handle network
} else if (error.contains('server')) {  // Fragile string matching
  // Handle server
}
```

### Solution with Failure Classes

**✅ Typed Errors:**
```dart
// Solution: Type-safe error handling
Future<Either<Failure, User>> getUser(int id) async {
  try {
    return Right(await api.getUser(id));
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Left(NetworkFailure(message: 'Connection timeout'));
    }
    return Left(ServerFailure(
      message: e.message ?? 'Server error',
      code: e.response?.statusCode,
    ));
  } catch (e) {
    return Left(UnknownFailure(
      message: 'Unexpected error',
      error: e,
    ));
  }
}

// Usage: Handle different error types specifically
result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      showNetworkError();  // Specific handling
    } else if (failure is ServerFailure) {
      showServerError(failure.code);  // Specific handling with code
    } else {
      showGenericError(failure.message);  // Fallback
    }
  },
  (user) => showUser(user),
);
```

**✅ Type-Safe Error Handling:**
```dart
// Compile-time checked error types
if (failure is NetworkFailure) {
  // TypeScript-like type narrowing
  // failure is guaranteed to be NetworkFailure here
  handleNetworkError(failure);
}
```

---

## 📦 Failure Types

### 1. `ServerFailure` - API/Server Errors

**Purpose:** Errors from API/server (500, 404, etc.)

**Properties:**
- `message` - Error message
- `code` - HTTP status code (optional)

**When to use:**
- API returns error status
- Server-side validation fails
- Resource not found (404)
- Server error (500)

**Example:**
```dart
ServerFailure(
  message: 'User not found',
  code: 404,
)

ServerFailure(
  message: 'Internal server error',
  code: 500,
)
```

### 2. `NetworkFailure` - Connection Errors

**Purpose:** Network/connection issues

**Properties:**
- `message` - Error message

**When to use:**
- No internet connection
- Connection timeout
- Network unreachable
- DNS resolution failed

**Example:**
```dart
NetworkFailure(message: 'No internet connection')
NetworkFailure(message: 'Connection timeout')
NetworkFailure(message: 'Network unreachable')
```

### 3. `CacheFailure` - Local Storage Errors

**Purpose:** Errors from local storage/cache

**Properties:**
- `message` - Error message

**When to use:**
- Failed to save to cache
- Failed to read from cache
- Cache corruption
- Storage full

**Example:**
```dart
CacheFailure(message: 'Failed to save to cache')
CacheFailure(message: 'Failed to read from cache')
CacheFailure(message: 'Cache corrupted')
```

### 4. `ValidationFailure` - Input Validation Errors

**Purpose:** Input validation errors

**Properties:**
- `message` - Error message

**When to use:**
- Invalid email format
- Password too short
- Required field missing
- Invalid input format

**Example:**
```dart
ValidationFailure(message: 'Email is invalid')
ValidationFailure(message: 'Password must be at least 8 characters')
ValidationFailure(message: 'This field is required')
```

### 5. `AuthFailure` - Authentication Errors

**Purpose:** Authentication/authorization errors

**Properties:**
- `message` - Error message
- `code` - Error code (optional)

**When to use:**
- Invalid credentials
- Token expired
- Unauthorized access
- Session expired

**Example:**
```dart
AuthFailure(
  message: 'Invalid credentials',
  code: 401,
)

AuthFailure(
  message: 'Token expired',
  code: 403,
)
```

### 6. `UnknownFailure` - Unexpected Errors

**Purpose:** Unexpected/unknown errors

**Properties:**
- `message` - Error message
- `error` - Original error object (optional)
- `stackTrace` - Stack trace (optional)

**When to use:**
- Unexpected exceptions
- Unknown error types
- Errors that don't fit other categories

**Example:**
```dart
UnknownFailure(
  message: 'Unexpected error occurred',
  error: exception,
  stackTrace: stackTrace,
)
```

### Failure Types Summary

| Type | Properties | Use Case |
|------|------------|----------|
| `ServerFailure` | message, code | API/server errors |
| `NetworkFailure` | message | Connection issues |
| `CacheFailure` | message | Local storage errors |
| `ValidationFailure` | message | Input validation |
| `AuthFailure` | message, code | Authentication errors |
| `UnknownFailure` | message, error, stackTrace | Unexpected errors |

---

## ✅ When to Use Each Type

### Use `ServerFailure` When:

- ✅ API returns error status (4xx, 5xx)
- ✅ Server-side validation fails
- ✅ Resource not found
- ✅ Server error

```dart
// ✅ Good - Server error
if (response.statusCode == 404) {
  return Left(ServerFailure(
    message: 'User not found',
    code: 404,
  ));
}
```

### Use `NetworkFailure` When:

- ✅ No internet connection
- ✅ Connection timeout
- ✅ Network unreachable
- ✅ DNS resolution failed

```dart
// ✅ Good - Network error
try {
  await api.getData();
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    return Left(NetworkFailure(message: 'Connection timeout'));
  }
}
```

### Use `CacheFailure` When:

- ✅ Failed to save to cache
- ✅ Failed to read from cache
- ✅ Cache corruption
- ✅ Storage full

```dart
// ✅ Good - Cache error
try {
  await cache.save(data);
} catch (e) {
  return Left(CacheFailure(message: 'Failed to save to cache'));
}
```

### Use `ValidationFailure` When:

- ✅ Invalid input format
- ✅ Required field missing
- ✅ Input doesn't meet requirements
- ✅ Business rule validation fails

```dart
// ✅ Good - Validation error
if (email.isEmpty || !email.contains('@')) {
  return Left(ValidationFailure(message: 'Invalid email format'));
}
```

### Use `AuthFailure` When:

- ✅ Invalid credentials
- ✅ Token expired
- ✅ Unauthorized access
- ✅ Session expired

```dart
// ✅ Good - Auth error
if (response.statusCode == 401) {
  return Left(AuthFailure(
    message: 'Invalid credentials',
    code: 401,
  ));
}
```

### Use `UnknownFailure` When:

- ✅ Unexpected exceptions
- ✅ Unknown error types
- ✅ Errors that don't fit other categories
- ✅ Need to preserve original error/stack trace

```dart
// ✅ Good - Unknown error
try {
  // Some operation
} catch (e, stackTrace) {
  return Left(UnknownFailure(
    message: 'Unexpected error occurred',
    error: e,
    stackTrace: stackTrace,
  ));
}
```

---

## 🔧 Using Failures with Either

### Pattern 1: Repository with Failure

```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    try {
      // Try remote first
      final user = await remoteDataSource.getUser(id);
      
      // Save to cache
      try {
        await localDataSource.saveUser(user);
      } catch (e) {
        // Cache error, but continue
        return Left(CacheFailure(message: 'Failed to save to cache'));
      }
      
      return Right(user);
    } on DioException catch (e) {
      // Network/Server error
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        // Fallback to local
        try {
          final user = await localDataSource.getUser(id);
          return Right(user);
        } catch (localError) {
          return Left(NetworkFailure(message: 'Connection timeout'));
        }
      }
      
      // Server error
      return Left(ServerFailure(
        message: e.message ?? 'Server error',
        code: e.response?.statusCode,
      ));
    } catch (e, stackTrace) {
      // Unknown error
      return Left(UnknownFailure(
        message: 'Unexpected error',
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
```

### Pattern 2: Use Case with Failure

```dart
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<Failure, LoginEntity>> call(LoginParams params) async {
    // Validation
    if (params.email.isEmpty || !params.email.contains('@')) {
      return Left(ValidationFailure(message: 'Invalid email format'));
    }
    
    if (params.password.length < 8) {
      return Left(ValidationFailure(
        message: 'Password must be at least 8 characters',
      ));
    }

    // Call repository
    return await authRepository.loginUser(params: params);
  }
}
```

### Pattern 3: Handling Failures in Cubit

```dart
class UserCubit extends Cubit<UserState> {
  final GetUserUseCase getUserUseCase;

  UserCubit({required this.getUserUseCase}) : super(UserState.initial());

  Future<void> loadUser(int id) async {
    emit(state.copyWith(isLoading: true));

    final result = await getUserUseCase.call(GetUserParams(id: id));

    result.fold(
      // Left: Handle failure
      (failure) {
        if (failure is NetworkFailure) {
          // Specific handling for network errors
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'No internet connection. Please check your network.',
          ));
        } else if (failure is ServerFailure) {
          // Specific handling for server errors
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Server error (${failure.code}). Please try again later.',
          ));
        } else if (failure is CacheFailure) {
          // Specific handling for cache errors
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Failed to save data locally.',
          ));
        } else if (failure is ValidationFailure) {
          // Specific handling for validation errors
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ));
        } else {
          // Generic handling for other errors
          emit(state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ));
        }
      },
      // Right: Handle success
      (user) {
        emit(state.copyWith(
          isLoading: false,
          user: user,
        ));
      },
    );
  }
}
```

---

## 📚 Complete Examples

### Example 1: API Call with Failure Handling

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    try {
      final response = await remoteDataSource.getProduct(id);
      return Right(response);
    } on DioException catch (e) {
      // Network errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return Left(NetworkFailure(message: 'Connection timeout'));
      }
      
      if (e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure(message: 'No internet connection'));
      }

      // Server errors
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        if (statusCode == 404) {
          return Left(ServerFailure(
            message: 'Product not found',
            code: 404,
          ));
        } else if (statusCode == 500) {
          return Left(ServerFailure(
            message: 'Internal server error',
            code: 500,
          ));
        } else {
          return Left(ServerFailure(
            message: e.message ?? 'Server error',
            code: statusCode,
          ));
        }
      }

      return Left(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (e, stackTrace) {
      return Left(UnknownFailure(
        message: 'Unexpected error',
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
```

### Example 2: Validation with Failure

```dart
class CreateUserUseCase extends UseCase<User, CreateUserParams> {
  final UserRepository userRepository;

  CreateUserUseCase({required this.userRepository});

  @override
  Future<Either<Failure, User>> call(CreateUserParams params) async {
    // Email validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure(message: 'Email is required'));
    }
    
    if (!params.email.contains('@')) {
      return Left(ValidationFailure(message: 'Invalid email format'));
    }

    // Password validation
    if (params.password.isEmpty) {
      return Left(ValidationFailure(message: 'Password is required'));
    }
    
    if (params.password.length < 8) {
      return Left(ValidationFailure(
        message: 'Password must be at least 8 characters',
      ));
    }

    // Name validation
    if (params.name.isEmpty) {
      return Left(ValidationFailure(message: 'Name is required'));
    }

    // Call repository
    return await userRepository.createUser(params: params);
  }
}
```

### Example 3: Cache Operations with Failure

```dart
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    try {
      final jsonString = sharedPreferences.getString('user_$id');
      
      if (jsonString == null) {
        return Left(CacheFailure(message: 'User not found in cache'));
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Right(User.fromJson(json));
    } catch (e) {
      if (e is FormatException) {
        return Left(CacheFailure(message: 'Cache data corrupted'));
      }
      return Left(CacheFailure(message: 'Failed to read from cache'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(User user) async {
    try {
      final json = user.toJson();
      final jsonString = jsonEncode(json);
      await sharedPreferences.setString('user_${user.id}', jsonString);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save to cache'));
    }
  }
}
```

### Example 4: Authentication with Failure

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, LoginEntity>> login(LoginParams params) async {
    try {
      final response = await remoteDataSource.login(params);
      return Right(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      
      if (statusCode == 401) {
        return Left(AuthFailure(
          message: 'Invalid credentials',
          code: 401,
        ));
      } else if (statusCode == 403) {
        return Left(AuthFailure(
          message: 'Access forbidden',
          code: 403,
        ));
      } else if (statusCode != null) {
        return Left(ServerFailure(
          message: e.message ?? 'Server error',
          code: statusCode,
        ));
      }
      
      return Left(NetworkFailure(message: 'Network error'));
    } catch (e, stackTrace) {
      return Left(UnknownFailure(
        message: 'Unexpected error',
        error: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
```

### Example 5: Error Handling in UI

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.error != null) {
          final failure = state.error!;
          
          if (failure is NetworkFailure) {
            // Show network error dialog
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Network Error'),
                content: const Text('Please check your internet connection.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (failure is ServerFailure) {
            // Show server error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (failure is ValidationFailure) {
            // Show validation error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.orange,
              ),
            );
          } else {
            // Generic error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        // Build UI
      },
    );
  }
}
```

---

## ⚖️ Failure vs ErrorMsg

### When to Use Failure Classes

**✅ Use Failure Classes When:**
- Need specific error types
- Different handling per error type
- Error categorization needed
- Need additional context (code, stack trace)
- Complex error handling

**Example:**
```dart
// ✅ Good - Typed failures
Future<Either<Failure, User>> getUser(int id);

result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      showNetworkError();
    } else if (failure is ServerFailure) {
      showServerError(failure.code);
    }
  },
  (user) => showUser(user),
);
```

### When to Use ErrorMsg (String)

**✅ Use ErrorMsg When:**
- Simple error messages are enough
- No need for error categorization
- Quick prototyping
- Simple error handling

**Example:**
```dart
// ✅ Good - Simple string errors
Future<Either<ErrorMsg, User>> getUser(int id);

result.fold(
  (error) => showError(error),  // Simple handling
  (user) => showUser(user),
);
```

### Comparison

| Aspect | Failure Classes | ErrorMsg (String) |
|--------|----------------|-------------------|
| **Type Safety** | ✅ Compile-time checked | ❌ Runtime only |
| **Categorization** | ✅ Yes (6 types) | ❌ No |
| **Specific Handling** | ✅ Yes | ❌ No |
| **Additional Context** | ✅ Yes (code, stack trace) | ❌ No |
| **Simplicity** | ⚠️ More complex | ✅ Simple |
| **Use Case** | Complex apps | Simple apps |

---

## ✅ Best Practices

### 1. **Use Appropriate Failure Type**

```dart
// ✅ Good - Correct failure type
if (e.type == DioExceptionType.connectionTimeout) {
  return Left(NetworkFailure(message: 'Connection timeout'));
}

// ❌ Bad - Wrong failure type
if (e.type == DioExceptionType.connectionTimeout) {
  return Left(ServerFailure(message: 'Connection timeout'));  // Wrong!
}
```

### 2. **Provide Meaningful Messages**

```dart
// ✅ Good - Descriptive message
return Left(NetworkFailure(message: 'No internet connection'));

// ❌ Bad - Generic message
return Left(NetworkFailure(message: 'Error'));
```

### 3. **Include Error Code When Available**

```dart
// ✅ Good - Include code
return Left(ServerFailure(
  message: 'User not found',
  code: 404,
));

// ❌ Bad - Missing code
return Left(ServerFailure(message: 'User not found'));  // Code missing
```

### 4. **Preserve Original Error in UnknownFailure**

```dart
// ✅ Good - Preserve error and stack trace
catch (e, stackTrace) {
  return Left(UnknownFailure(
    message: 'Unexpected error',
    error: e,
    stackTrace: stackTrace,
  ));
}

// ❌ Bad - Lose original error
catch (e) {
  return Left(UnknownFailure(message: 'Unexpected error'));  // Lost error
}
```

### 5. **Handle Failures Specifically**

```dart
// ✅ Good - Specific handling
result.fold(
  (failure) {
    if (failure is NetworkFailure) {
      handleNetworkError();
    } else if (failure is ServerFailure) {
      handleServerError(failure.code);
    }
  },
  (data) => handleSuccess(data),
);

// ❌ Bad - Generic handling
result.fold(
  (failure) => showError(failure.message),  // All errors treated same
  (data) => handleSuccess(data),
);
```

### 6. **Use Type Narrowing**

```dart
// ✅ Good - Type narrowing
if (failure is NetworkFailure) {
  // failure is NetworkFailure here
  handleNetworkError(failure);
}

// ❌ Bad - Type checking without narrowing
if (failure.runtimeType == NetworkFailure) {
  // Still need casting
  handleNetworkError(failure as NetworkFailure);
}
```

---

## 🔄 Common Patterns

### Pattern 1: API Error Handling

```dart
try {
  final response = await api.getData();
  return Right(response);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    return Left(NetworkFailure(message: 'Connection timeout'));
  }
  
  final statusCode = e.response?.statusCode;
  if (statusCode != null) {
    return Left(ServerFailure(
      message: e.message ?? 'Server error',
      code: statusCode,
    ));
  }
  
  return Left(NetworkFailure(message: 'Network error'));
} catch (e, stackTrace) {
  return Left(UnknownFailure(
    message: 'Unexpected error',
    error: e,
    stackTrace: stackTrace,
  ));
}
```

### Pattern 2: Validation Chain

```dart
Future<Either<Failure, User>> createUser(CreateUserParams params) async {
  // Validate email
  if (params.email.isEmpty) {
    return Left(ValidationFailure(message: 'Email is required'));
  }
  
  if (!params.email.contains('@')) {
    return Left(ValidationFailure(message: 'Invalid email format'));
  }

  // Validate password
  if (params.password.length < 8) {
    return Left(ValidationFailure(
      message: 'Password must be at least 8 characters',
    ));
  }

  // Call repository
  return await repository.createUser(params: params);
}
```

### Pattern 3: Fallback with Cache

```dart
Future<Either<Failure, Data>> getData() async {
  try {
    // Try remote
    final data = await remoteDataSource.getData();
    return Right(data);
  } on DioException catch (e) {
    // Network error - fallback to cache
    if (e.type == DioExceptionType.connectionTimeout) {
      try {
        final cachedData = await localDataSource.getData();
        return Right(cachedData);
      } catch (cacheError) {
        return Left(NetworkFailure(message: 'Connection timeout'));
      }
    }
    return Left(NetworkFailure(message: 'Network error'));
  } catch (e) {
    return Left(UnknownFailure(message: 'Unexpected error', error: e));
  }
}
```

---

## 📋 Quick Reference

### Failure Types

| Type | Properties | Use Case |
|------|------------|----------|
| `ServerFailure` | message, code | API/server errors |
| `NetworkFailure` | message | Connection issues |
| `CacheFailure` | message | Local storage errors |
| `ValidationFailure` | message | Input validation |
| `AuthFailure` | message, code | Authentication errors |
| `UnknownFailure` | message, error, stackTrace | Unexpected errors |

### File Locations

- **Failure Classes**: `lib/core/functional/failure.dart`
- **ErrorMsg**: `lib/core/failure/exceptions.dart`
- **Export**: `lib/core/functional/functional_export.dart`

---

## ✅ Checklist

When using Failure classes:

- [ ] Choose appropriate failure type
- [ ] Provide meaningful error messages
- [ ] Include error code when available
- [ ] Preserve original error in UnknownFailure
- [ ] Handle failures specifically in UI
- [ ] Use type narrowing for specific handling
- [ ] Document failure types in repository/use case

---

## 🎯 Summary

1. ✅ **6 Failure Types** - Server, Network, Cache, Validation, Auth, Unknown
2. ✅ **Type Safety** - Compile-time checked error types
3. ✅ **Specific Handling** - Different handling per error type
4. ✅ **More Information** - Additional context (code, stack trace)
5. ✅ **Better Debugging** - Clear error types in logs
6. ✅ **Use with Either** - `Either<Failure, T>` for type-safe errors
7. ✅ **Best Practices** - Appropriate types, meaningful messages, specific handling

---

**Why Failure Classes?** They provide **type-safe, categorized error handling** with **specific handling per error type** - essential for robust Flutter applications!
