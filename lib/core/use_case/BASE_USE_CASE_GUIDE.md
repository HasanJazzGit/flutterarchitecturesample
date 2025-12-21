# 🎯 Base Use Case Guide

Complete guide for using base use case interfaces in Flutter - when, why, and how to implement them.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What are Use Cases?](#what-are-use-cases)
3. [Base Use Case Types](#base-use-case-types)
4. [When to Use Each Type](#when-to-use-each-type)
5. [Implementation Guide](#implementation-guide)
6. [Complete Examples](#complete-examples)
7. [Best Practices](#best-practices)
8. [Common Patterns](#common-patterns)
9. [Troubleshooting](#troubleshooting)

---

## 📖 Overview

**Use Cases** encapsulate business logic in Clean Architecture. They represent a single action or operation that the application can perform.

### Benefits
- ✅ Single Responsibility Principle
- ✅ Reusable business logic
- ✅ Testable in isolation
- ✅ Type-safe error handling
- ✅ Clear separation of concerns

### File Location

```
lib/core/use_case/
└── base_use_case.dart    # Base use case interfaces
```

---

## 🎯 What are Use Cases?

**Use Cases** are the business logic layer between the presentation (UI) and data layers. They:

1. **Encapsulate** a single business operation
2. **Use repositories** (not data sources directly)
3. **Return** `Either<ErrorMsg, T>` for error handling
4. **Have no UI dependencies**
5. **Can contain validation** and business rules

### Use Case Flow

```
UI (Cubit) → Use Case → Repository → Data Source → API/Database
                ↓
         Business Logic
         Validation
         Error Handling
```

---

## 📦 Base Use Case Types

The project provides **4 base use case interfaces** to cover all scenarios:

### 1. `UseCase<T, Params>` - Standard Use Case

**Has return type AND parameters.**

```dart
abstract class UseCase<T, Params> {
  Future<Either<ErrorMsg, T>> call(Params params);
}
```

**When to use:**
- ✅ Most common use case
- ✅ Has input parameters
- ✅ Returns data

**Example:**
```dart
// Login use case - takes params, returns entity
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  // ...
}
```

### 2. `UseCaseNoParams<T>` - No Parameters

**Has return type but NO parameters.**

```dart
abstract class UseCaseNoParams<T> {
  Future<Either<ErrorMsg, T>> call();
}
```

**When to use:**
- ✅ No input needed
- ✅ Returns data
- ✅ Get all items, get current user, etc.

**Example:**
```dart
// Get all features - no params, returns list
class GetFeaturesUseCase extends UseCaseNoParams<List<FeatureEntity>> {
  // ...
}
```

### 3. `UseCaseVoid<Params>` - Void Return

**Has parameters but NO return type (void).**

```dart
abstract class UseCaseVoid<Params> {
  Future<Either<ErrorMsg, void>> call(Params params);
}
```

**When to use:**
- ✅ Has input parameters
- ✅ No return value needed
- ✅ Delete, logout, etc.

**Example:**
```dart
// Delete user - takes params, returns void
class DeleteUserUseCase extends UseCaseVoid<DeleteUserParams> {
  // ...
}
```

### 4. `UseCaseVoidNoParams` - Void Return, No Parameters

**NO parameters and NO return type (void).**

```dart
abstract class UseCaseVoidNoParams {
  Future<Either<ErrorMsg, void>> call();
}
```

**When to use:**
- ✅ No input needed
- ✅ No return value
- ✅ Logout, clear cache, etc.

**Example:**
```dart
// Logout - no params, no return
class LogoutUseCase extends UseCaseVoidNoParams {
  // ...
}
```

### Base Use Case Types Summary

| Type | Parameters | Return Type | Use Case |
|------|------------|-------------|----------|
| `UseCase<T, Params>` | ✅ Yes | ✅ Yes | Most common |
| `UseCaseNoParams<T>` | ❌ No | ✅ Yes | Get all, get current |
| `UseCaseVoid<Params>` | ✅ Yes | ❌ No | Delete, update |
| `UseCaseVoidNoParams` | ❌ No | ❌ No | Logout, clear |

---

## ✅ When to Use Each Type

### Use `UseCase<T, Params>` When:

- ✅ **Most common scenario**
- ✅ You have input parameters
- ✅ You need to return data
- ✅ Examples: Login, Create, Update, Get by ID

```dart
// ✅ Good - Has params and returns data
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  // Takes email/password, returns login entity
}

class CreateProductUseCase extends UseCase<ProductEntity, CreateProductParams> {
  // Takes product data, returns created product
}
```

### Use `UseCaseNoParams<T>` When:

- ✅ No input parameters needed
- ✅ Returns data
- ✅ Examples: Get all items, get current user, get settings

```dart
// ✅ Good - No params, returns data
class GetFeaturesUseCase extends UseCaseNoParams<List<FeatureEntity>> {
  // No input, returns list of features
}

class GetCurrentUserUseCase extends UseCaseNoParams<UserEntity> {
  // No input, returns current user
}
```

### Use `UseCaseVoid<Params>` When:

- ✅ Has input parameters
- ✅ No return value needed
- ✅ Examples: Delete, Update (if no return needed)

```dart
// ✅ Good - Has params, no return
class DeleteUserUseCase extends UseCaseVoid<DeleteUserParams> {
  // Takes user ID, returns void
}

class UpdateUserUseCase extends UseCaseVoid<UpdateUserParams> {
  // Takes update data, returns void
}
```

### Use `UseCaseVoidNoParams` When:

- ✅ No input parameters
- ✅ No return value
- ✅ Examples: Logout, clear cache, reset

```dart
// ✅ Good - No params, no return
class LogoutUseCase extends UseCaseVoidNoParams {
  // No input, no return
}

class ClearCacheUseCase extends UseCaseVoidNoParams {
  // No input, no return
}
```

---

## 🔧 Implementation Guide

### Step 1: Choose the Right Base Use Case

**Ask yourself:**
1. Do I need input parameters? → Yes/No
2. Do I need to return data? → Yes/No

**Decision Tree:**
```
Need params?
├─ Yes → Need return?
│   ├─ Yes → UseCase<T, Params>
│   └─ No → UseCaseVoid<Params>
└─ No → Need return?
    ├─ Yes → UseCaseNoParams<T>
    └─ No → UseCaseVoidNoParams
```

### Step 2: Create Params Class (if needed)

**If using `UseCase<T, Params>` or `UseCaseVoid<Params>`:**

```dart
// Create params class extending Equatable
class MyParams extends Equatable {
  final String field1;
  final int field2;

  const MyParams({
    required this.field1,
    required this.field2,
  });

  @override
  List<Object?> get props => [field1, field2];
}
```

**Best Practices:**
- ✅ Extend `Equatable` for comparison
- ✅ Use `const` constructor
- ✅ Make fields `final`
- ✅ Override `props` for equality

### Step 3: Implement Use Case

**Template for `UseCase<T, Params>`:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/my_entity.dart';
import '../repositories/my_repository.dart';

class MyUseCase extends UseCase<MyEntity, MyParams> {
  final MyRepository repository;

  MyUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
    // Optional: Add validation
    if (params.field1.isEmpty) {
      return const Left('Field1 cannot be empty');
    }

    // Call repository
    return await repository.doSomething(params: params);
  }
}
```

**Template for `UseCaseNoParams<T>`:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/my_entity.dart';
import '../repositories/my_repository.dart';

class GetMyDataUseCase extends UseCaseNoParams<List<MyEntity>> {
  final MyRepository repository;

  GetMyDataUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, List<MyEntity>>> call() async {
    return await repository.getAll();
  }
}
```

**Template for `UseCaseVoid<Params>`:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/my_repository.dart';

class DeleteMyDataUseCase extends UseCaseVoid<DeleteMyDataParams> {
  final MyRepository repository;

  DeleteMyDataUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, void>> call(DeleteMyDataParams params) async {
    return await repository.delete(params: params);
  }
}
```

**Template for `UseCaseVoidNoParams`:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/my_repository.dart';

class LogoutUseCase extends UseCaseVoidNoParams {
  final MyRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<Either<ErrorMsg, void>> call() async {
    return await repository.logout();
  }
}
```

### Step 4: Register in Dependency Injection

**Register use case in feature injection file:**

```dart
// my_feature_injection.dart
import 'package:get_it/get_it.dart';
import '../domain/use_cases/my_use_case.dart';
import '../domain/repositories/my_repository.dart';

final sl = GetIt.instance;

void setupMyFeatureInjection() {
  // Use cases
  sl.registerFactory<MyUseCase>(
    () => MyUseCase(repository: sl<MyRepository>()),
  );
}
```

### Step 5: Use in Cubit

**Call use case in Cubit:**

```dart
class MyCubit extends Cubit<MyState> {
  final MyUseCase myUseCase;

  MyCubit({required this.myUseCase}) : super(MyState.initial());

  Future<void> doSomething(String field1, int field2) async {
    emit(state.copyWith(isLoading: true));

    final result = await myUseCase.call(MyParams(
      field1: field1,
      field2: field2,
    ));

    result.fold(
      (error) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: error,
        ));
      },
      (data) {
        emit(state.copyWith(
          isLoading: false,
          data: data,
        ));
      },
    );
  }
}
```

---

## 📚 Complete Examples

### Example 1: `UseCase<T, Params>` - Login

**Params:**
```dart
// login_use_case.dart
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
```

**Use Case:**
```dart
// login_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, LoginEntity>> call(LoginParams params) async {
    return await authRepository.loginUser(params: params);
  }
}
```

**Usage in Cubit:**
```dart
final result = await loginUseCase.call(LoginParams(
  email: email,
  password: password,
));

result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (loginEntity) => emit(state.copyWith(loginEntity: loginEntity)),
);
```

### Example 2: `UseCaseNoParams<T>` - Get All Features

**Use Case:**
```dart
// clean_get_features_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/clean_feature_entity.dart';
import '../repositories/clean_feature_repository.dart';

class CleanGetFeaturesUseCase
    implements UseCaseNoParams<List<CleanFeatureEntity>> {
  final CleanFeatureRepository featureRepository;

  CleanGetFeaturesUseCase({required this.featureRepository});

  @override
  Future<Either<ErrorMsg, List<CleanFeatureEntity>>> call() async {
    return await featureRepository.getFeatures();
  }
}
```

**Usage in Cubit:**
```dart
final result = await getFeaturesUseCase.call();

result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (features) => emit(state.copyWith(features: features)),
);
```

### Example 3: `UseCase<T, Params>` - Create Feature

**Params:**
```dart
// create_feature_params.dart
import 'package:equatable/equatable.dart';

class CreateFeatureParams extends Equatable {
  final String title;
  final String content;

  const CreateFeatureParams({
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [title, content];
}
```

**Use Case:**
```dart
// clean_create_feature_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/clean_feature_entity.dart';
import '../repositories/clean_feature_repository.dart';
import 'create_feature_params.dart';

class CleanCreateFeatureUseCase
    extends UseCase<CleanFeatureEntity, CreateFeatureParams> {
  final CleanFeatureRepository featureRepository;

  CleanCreateFeatureUseCase({required this.featureRepository});

  @override
  Future<Either<ErrorMsg, CleanFeatureEntity>> call(
    CreateFeatureParams params,
  ) async {
    // Optional: Add validation
    if (params.title.isEmpty) {
      return const Left('Title cannot be empty');
    }
    if (params.content.isEmpty) {
      return const Left('Content cannot be empty');
    }

    return await featureRepository.createFeature(params);
  }
}
```

**Usage in Cubit:**
```dart
final result = await createFeatureUseCase.call(
  CreateFeatureParams(title: title, content: content),
);

result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (feature) {
    final updatedFeatures = [feature, ...state.features];
    emit(state.copyWith(features: updatedFeatures));
  },
);
```

### Example 4: `UseCaseVoid<Params>` - Delete User

**Params:**
```dart
class DeleteUserParams extends Equatable {
  final String userId;

  const DeleteUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
```

**Use Case:**
```dart
class DeleteUserUseCase extends UseCaseVoid<DeleteUserParams> {
  final UserRepository userRepository;

  DeleteUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, void>> call(DeleteUserParams params) async {
    return await userRepository.deleteUser(params: params);
  }
}
```

**Usage in Cubit:**
```dart
final result = await deleteUserUseCase.call(
  DeleteUserParams(userId: userId),
);

result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (_) {
    // Success - remove from list
    final updatedUsers = state.users
        .where((user) => user.id != userId)
        .toList();
    emit(state.copyWith(users: updatedUsers));
  },
);
```

### Example 5: `UseCaseVoidNoParams` - Logout

**Use Case:**
```dart
class LogoutUseCase extends UseCaseVoidNoParams {
  final AuthRepository authRepository;

  LogoutUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, void>> call() async {
    return await authRepository.logout();
  }
}
```

**Usage in Cubit:**
```dart
final result = await logoutUseCase.call();

result.fold(
  (error) => emit(state.copyWith(errorMessage: error)),
  (_) {
    // Success - clear state and navigate
    emit(const AuthState());
    context.go(AppRoutes.path(AppRoutes.login));
  },
);
```

---

## ✅ Best Practices

### 1. **Single Responsibility**

```dart
// ✅ Good - One use case, one action
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  // Only handles login
}

// ❌ Bad - Multiple actions
class AuthUseCase extends UseCase<AuthEntity, AuthParams> {
  // Handles login, register, logout - too many responsibilities
}
```

### 2. **Use Repository, Not Data Source**

```dart
// ✅ Good - Uses repository
class MyUseCase extends UseCase<MyEntity, MyParams> {
  final MyRepository repository; // ✅ Repository

  @override
  Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
    return await repository.doSomething(params: params);
  }
}

// ❌ Bad - Uses data source directly
class MyUseCase extends UseCase<MyEntity, MyParams> {
  final MyRemoteDataSource dataSource; // ❌ Data source

  @override
  Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
    return await dataSource.getData(); // ❌ Bypasses repository
  }
}
```

### 3. **Add Validation in Use Case**

```dart
// ✅ Good - Validates in use case
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  // Validate input
  if (params.email.isEmpty) {
    return const Left('Email cannot be empty');
  }
  if (!params.email.contains('@')) {
    return const Left('Invalid email format');
  }

  // Call repository
  return await repository.doSomething(params: params);
}
```

### 4. **Use Equatable for Params**

```dart
// ✅ Good - Extends Equatable
class MyParams extends Equatable {
  final String field1;
  final int field2;

  const MyParams({required this.field1, required this.field2});

  @override
  List<Object?> get props => [field1, field2];
}

// ❌ Bad - No Equatable
class MyParams { // ❌ Cannot compare
  final String field1;
  MyParams({required this.field1});
}
```

### 5. **Return Either, Don't Throw**

```dart
// ✅ Good - Returns Either
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  try {
    final result = await repository.doSomething(params: params);
    return Right(result);
  } catch (e) {
    return Left('Error: ${e.toString()}');
  }
}

// ❌ Bad - Throws exceptions
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  if (params.field1.isEmpty) {
    throw Exception('Field1 is empty'); // ❌ Don't throw
  }
  return await repository.doSomething(params: params);
}
```

### 6. **No UI Dependencies**

```dart
// ✅ Good - No UI dependencies
class MyUseCase extends UseCase<MyEntity, MyParams> {
  final MyRepository repository;
  // No BuildContext, no Widget, no UI code
}

// ❌ Bad - UI dependencies
class MyUseCase extends UseCase<MyEntity, MyParams> {
  final BuildContext context; // ❌ UI dependency
  final Navigator navigator; // ❌ UI dependency
}
```

### 7. **Register as Factory**

```dart
// ✅ Good - Register as factory
sl.registerFactory<MyUseCase>(
  () => MyUseCase(repository: sl<MyRepository>()),
);

// ❌ Bad - Register as singleton (usually)
sl.registerSingleton<MyUseCase>(
  MyUseCase(repository: sl<MyRepository>()),
); // ❌ Use factory for use cases
```

---

## 🔄 Common Patterns

### Pattern 1: Validation Before Repository Call

```dart
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  // Validate
  if (params.field1.isEmpty) {
    return const Left('Field1 is required');
  }

  // Call repository
  return await repository.doSomething(params: params);
}
```

### Pattern 2: Transform Repository Result

```dart
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  final result = await repository.doSomething(params: params);
  
  return result.map((data) {
    // Transform data if needed
    return MyEntity(
      id: data.id,
      name: data.name.toUpperCase(),
    );
  });
}
```

### Pattern 3: Chain Multiple Operations

```dart
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  // Step 1: Get user
  final userResult = await repository.getUser(params.userId);
  
  return userResult.flatMap((user) async {
    // Step 2: Update user (only if step 1 succeeds)
    return await repository.updateUser(user, params.data);
  });
}
```

### Pattern 4: Use Case with Business Logic

```dart
@override
Future<Either<ErrorMsg, OrderEntity>> call(CreateOrderParams params) async {
  // Business logic: Check stock
  final stockResult = await repository.checkStock(params.productId);
  
  return stockResult.flatMap((stock) async {
    if (stock.quantity < params.quantity) {
      return Left('Insufficient stock. Available: ${stock.quantity}');
    }
    
    // Business logic: Calculate price
    final price = stock.price * params.quantity;
    
    // Create order
    return await repository.createOrder(
      CreateOrderParams(
        productId: params.productId,
        quantity: params.quantity,
        price: price,
      ),
    );
  });
}
```

---

## 🐛 Troubleshooting

### Issue 1: Wrong Base Use Case Type

**Problem:**
```dart
// Using UseCase when should use UseCaseNoParams
class GetUsersUseCase extends UseCase<List<User>, NoParams> {
  // ...
}
```

**Solution:**
```dart
// ✅ Use UseCaseNoParams
class GetUsersUseCase extends UseCaseNoParams<List<User>> {
  @override
  Future<Either<ErrorMsg, List<User>>> call() async {
    // No params needed
  }
}
```

### Issue 2: Params Not Extending Equatable

**Problem:**
```dart
class MyParams { // ❌ Not Equatable
  final String field1;
}
```

**Solution:**
```dart
// ✅ Extend Equatable
class MyParams extends Equatable {
  final String field1;
  
  const MyParams({required this.field1});
  
  @override
  List<Object?> get props => [field1];
}
```

### Issue 3: Using Data Source Instead of Repository

**Problem:**
```dart
class MyUseCase {
  final MyRemoteDataSource dataSource; // ❌ Wrong layer
}
```

**Solution:**
```dart
// ✅ Use repository
class MyUseCase {
  final MyRepository repository; // ✅ Correct layer
}
```

### Issue 4: Throwing Exceptions

**Problem:**
```dart
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  if (params.field1.isEmpty) {
    throw Exception('Error'); // ❌ Don't throw
  }
}
```

**Solution:**
```dart
// ✅ Return Left
@override
Future<Either<ErrorMsg, MyEntity>> call(MyParams params) async {
  if (params.field1.isEmpty) {
    return const Left('Field1 cannot be empty'); // ✅ Return error
  }
}
```

### Issue 5: UI Dependencies in Use Case

**Problem:**
```dart
class MyUseCase {
  final BuildContext context; // ❌ UI dependency
  final Navigator navigator; // ❌ UI dependency
}
```

**Solution:**
```dart
// ✅ Remove UI dependencies
class MyUseCase {
  final MyRepository repository; // ✅ Only business logic
}
```

---

## 📋 Quick Reference

### Base Use Case Types

| Type | Parameters | Return | Example |
|------|------------|--------|---------|
| `UseCase<T, Params>` | ✅ | ✅ | Login, Create |
| `UseCaseNoParams<T>` | ❌ | ✅ | Get All, Get Current |
| `UseCaseVoid<Params>` | ✅ | ❌ | Delete, Update |
| `UseCaseVoidNoParams` | ❌ | ❌ | Logout, Clear |

### Implementation Checklist

- [ ] Choose correct base use case type
- [ ] Create params class (if needed) extending Equatable
- [ ] Implement `call()` method
- [ ] Use repository (not data source)
- [ ] Return `Either<ErrorMsg, T>`
- [ ] Add validation (optional)
- [ ] Register in dependency injection
- [ ] Use in Cubit with `fold()`

### File Locations

- **Base Use Cases**: `lib/core/use_case/base_use_case.dart`
- **Use Cases**: `lib/features/[feature]/domain/use_cases/`
- **Params**: `lib/features/[feature]/domain/use_cases/[name]_params.dart`

---

## ✅ Summary

1. ✅ **4 Base Types** - Cover all scenarios (params/return combinations)
2. ✅ **Single Responsibility** - One use case = one action
3. ✅ **Use Repository** - Not data sources directly
4. ✅ **Return Either** - Type-safe error handling
5. ✅ **No UI Dependencies** - Pure business logic
6. ✅ **Add Validation** - In use case, not repository
7. ✅ **Use Equatable** - For params comparison

---

**Why Use Cases?** They provide **reusable, testable business logic** with **type-safe error handling** - the heart of Clean Architecture!
