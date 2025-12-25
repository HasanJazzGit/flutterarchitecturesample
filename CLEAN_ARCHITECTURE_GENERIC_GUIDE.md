# 🏗️ Clean Architecture - Complete Guide with Examples

A comprehensive guide to understanding and implementing Clean Architecture in Flutter with real-world examples and code snippets.

---

## 📋 Table of Contents

1. [What is Clean Architecture?](#what-is-clean-architecture)
2. [Core Principles](#core-principles)
3. [Layer Structure](#layer-structure)
4. [Complete Example: Login Feature](#complete-example-login-feature)
5. [Code Snippets](#code-snippets)
6. [Best Practices](#best-practices)
7. [Common Patterns](#common-patterns)
8. [Testing Strategy](#testing-strategy)

---

## 🎯 What is Clean Architecture?

Clean Architecture is a software design pattern that separates your application into **layers** with clear boundaries and dependencies. The main goal is to make your code:

- ✅ **Independent** of frameworks, UI, and databases
- ✅ **Testable** - each layer can be tested in isolation
- ✅ **Maintainable** - changes in one layer don't affect others
- ✅ **Scalable** - easy to add new features

### The Dependency Rule

```
Outer layers depend on inner layers
Inner layers NEVER depend on outer layers

Presentation → Domain ← Data
     ↓           ↑        ↓
     └───────────┴────────┘
```

**Key Point:** Dependencies point **inward** toward the Domain layer.

---

## 🏛️ Core Principles

### 1. **Separation of Concerns**
Each layer has a single, well-defined responsibility.

### 2. **Dependency Inversion**
Depend on abstractions (interfaces), not concrete implementations.

### 3. **Independence**
- Business logic is independent of UI
- Business logic is independent of data sources
- Framework-independent code

### 4. **Testability**
Each layer can be tested independently with mocks.

---

## 📦 Layer Structure

```
┌─────────────────────────────────────────────────────────┐
│                  PRESENTATION LAYER                      │
│  (UI, State Management, Widgets)                         │
│  • Depends on: Domain only                                │
│  • Contains: Pages, Widgets, Cubits/Blocs                │
└─────────────────────────────────────────────────────────┘
                        ↓ Uses
┌─────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                          │
│  (Business Logic - Pure Dart)                            │
│  • Depends on: Nothing (Pure Dart)                       │
│  • Contains: Entities, Use Cases, Repository Interfaces   │
└─────────────────────────────────────────────────────────┘
                        ↑ Implemented by
┌─────────────────────────────────────────────────────────┐
│                     DATA LAYER                           │
│  (External Data Sources)                                  │
│  • Depends on: Domain, Core                              │
│  • Contains: Models, Data Sources, Repository Impl       │
└─────────────────────────────────────────────────────────┘
                        ↓ Uses
┌─────────────────────────────────────────────────────────┐
│                  CORE/INFRASTRUCTURE                     │
│  (Shared Utilities)                                       │
│  • Depends on: Nothing                                   │
│  • Contains: Network, Storage, DI, Utils                 │
└─────────────────────────────────────────────────────────┘
```

---

## 🎓 Complete Example: Login Feature

Let's build a complete login feature following Clean Architecture principles.

### Step 1: Domain Layer - Entity

**Purpose:** Pure business object, no dependencies

**File:** `lib/features/auth/domain/entities/login_entity.dart`

```dart
import 'package:equatable/equatable.dart';

/// Business entity representing login response
/// Pure Dart class - no external dependencies
class LoginEntity extends Equatable {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final DateTime? expiresAt;

  const LoginEntity({
    required this.token,
    required this.userId,
    required this.email,
    this.refreshToken,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [token, userId, email, refreshToken, expiresAt];
}
```

**Key Points:**
- ✅ Pure Dart class (no Flutter, no HTTP, no database)
- ✅ Uses `Equatable` for value equality
- ✅ Represents business concept, not API structure
- ✅ Immutable (all fields are `final`)

---

### Step 2: Domain Layer - Repository Interface

**Purpose:** Contract for data access (abstraction)

**File:** `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/login_entity.dart';
import '../use_cases/login_use_case.dart';

/// Repository interface - defines contract for authentication
/// Domain layer only knows about this interface, not implementation
abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<ErrorMsg, LoginEntity>> loginUser({
    required LoginParams params,
  });

  /// Logout user
  Future<Either<ErrorMsg, void>> logout();

  /// Check if user is authenticated
  Future<Either<ErrorMsg, bool>> isAuthenticated();
}
```

**Key Points:**
- ✅ Abstract class (interface)
- ✅ Returns `Either<ErrorMsg, T>` for error handling
- ✅ Uses Domain entities (LoginEntity)
- ✅ No implementation details

---

### Step 3: Domain Layer - Use Case

**Purpose:** Single business operation

**File:** `lib/features/auth/domain/use_cases/login_use_case.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/login_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
/// Encapsulates business logic for login operation
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, LoginEntity>> call(LoginParams params) async {
    // Business logic: Validate input, call repository
    return await authRepository.loginUser(params: params);
  }
}

/// Parameters for login use case
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
```

**Key Points:**
- ✅ Extends `UseCase<T, Params>` base class
- ✅ Takes repository interface (not implementation)
- ✅ Returns `Either<ErrorMsg, T>`
- ✅ Single responsibility: login operation
- ✅ Can contain validation logic

---

### Step 4: Data Layer - Model

**Purpose:** Represents API response structure

**File:** `lib/features/auth/data/models/login_response.dart`

```dart
/// Data model representing API response
/// Matches JSON structure from backend
class LoginResponse {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final int? expiresIn;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.email,
    this.refreshToken,
    this.expiresIn,
  });

  /// Create from JSON (API response)
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresIn: json['expiresIn'] as int?,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
      'email': email,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}
```

**Key Points:**
- ✅ Matches API response structure
- ✅ Has `fromJson` and `toJson` methods
- ✅ Can have different structure than Entity
- ✅ Part of Data layer

---

### Step 5: Data Layer - Mapper

**Purpose:** Converts Model to Entity

**File:** `lib/features/auth/data/mappers/login_mapper.dart`

```dart
import '../../domain/entities/login_entity.dart';
import '../models/login_response.dart';

/// Mapper to convert Data Model to Domain Entity
class LoginMapper {
  /// Convert LoginResponse (Model) to LoginEntity (Entity)
  static LoginEntity toEntity(LoginResponse response) {
    return LoginEntity(
      token: response.token,
      userId: response.userId,
      email: response.email,
      refreshToken: response.refreshToken,
      expiresAt: response.expiresIn != null
          ? DateTime.now().add(Duration(seconds: response.expiresIn!))
          : null,
    );
  }
}
```

**Key Points:**
- ✅ Converts Model → Entity
- ✅ Handles data transformation
- ✅ Business logic (e.g., calculating expiresAt)
- ✅ Static methods for easy use

---

### Step 6: Data Layer - Data Source Interface

**Purpose:** Contract for data source

**File:** `lib/features/auth/data/data_sources/auth_remote_data_source.dart`

```dart
import '../../domain/use_cases/login_use_case.dart';
import '../models/login_response.dart';

/// Abstract data source for authentication
abstract class AuthRemoteDataSource {
  Future<LoginResponse> login({required LoginParams params});
  Future<void> logout();
}
```

**Key Points:**
- ✅ Abstract class (interface)
- ✅ Returns Models (not Entities)
- ✅ Defines data source contract

---

### Step 7: Data Layer - Data Source Implementation

**Purpose:** Actual API calls

**File:** `lib/features/auth/data/data_sources/auth_remote_data_source_impl.dart`

```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_urls.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../models/login_response.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<LoginResponse> login({required LoginParams params}) async {
    try {
      // Make HTTP request
      final response = await apiClient.post(
        AppUrls.login,
        body: {
          'email': params.email,
          'password': params.password,
        },
      );

      // Convert JSON to Model
      return LoginResponse.fromJson(response);
    } catch (e) {
      // Handle errors
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    await apiClient.post(AppUrls.logout);
  }
}
```

**Key Points:**
- ✅ Implements data source interface
- ✅ Uses ApiClient (from Core)
- ✅ Returns Models
- ✅ Handles network errors

---

### Step 8: Data Layer - Repository Implementation

**Purpose:** Implements Domain repository interface

**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

```dart
import '../../../../core/functional/functional_export.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../mappers/login_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AppPref _appPref;

  AuthRepositoryImpl(this.remoteDataSource, {AppPref? appPref})
    : _appPref = appPref ?? sl<AppPref>();

  @override
  Future<Either<ErrorMsg, LoginEntity>> loginUser({
    required LoginParams params,
  }) async {
    try {
      // Call data source (returns Model)
      final response = await remoteDataSource.login(params: params);
      
      // Convert Model to Entity
      final entity = LoginMapper.toEntity(response);
      
      // Return success
      return Right(entity);
    } on ApiException catch (e) {
      // Handle API errors
      return Left(e.message);
    } catch (e) {
      // Handle other errors
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await _appPref.logout();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, bool>> isAuthenticated() async {
    try {
      final isAuth = _appPref.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
```

**Key Points:**
- ✅ Implements Domain repository interface
- ✅ Uses Data Source
- ✅ Converts Model → Entity using Mapper
- ✅ Returns `Either<ErrorMsg, T>`
- ✅ Handles errors

---

### Step 9: Presentation Layer - State

**Purpose:** Immutable state for UI

**File:** `lib/features/auth/presentation/cubit/auth_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/state_status.dart';
import '../../domain/entities/login_entity.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(StateStatus.initial) StateStatus loginStatus,
    @Default(false) bool rememberMe,
    LoginEntity? loginEntity,
  }) = _AuthState;
}
```

**Key Points:**
- ✅ Uses Freezed for immutability
- ✅ Contains UI state
- ✅ Uses Domain entities

---

### Step 10: Presentation Layer - Cubit

**Purpose:** State management, connects UI to Use Cases

**File:** `lib/features/auth/presentation/cubit/auth_cubit.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/preference/app_pref.dart';
import '../../domain/use_cases/login_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(const AuthState());

  Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // Emit loading state
    emit(state.copyWith(loginStatus: StateStatus.loading));

    // Create params
    final params = LoginParams(email: email, password: password);
    
    // Call use case
    final result = await loginUseCase.call(params);

    // Handle result
    result.fold(
      // Left: Error
      (error) {
        emit(state.copyWith(loginStatus: StateStatus.error));
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      },
      // Right: Success
      (response) async {
        // Save token
        final appPref = sl<AppPref>();
        await appPref.setToken(response.token);
        
        // Update API client
        sl<ApiClient>().setAuthToken(response.token);

        // Emit success
        emit(state.copyWith(
          loginStatus: StateStatus.success,
          loginEntity: response,
        ));
        
        // Navigate
        Navigator.pushReplacementNamed(context, '/home');
      },
    );
  }
}
```

**Key Points:**
- ✅ Uses Use Case (not Repository directly)
- ✅ Handles UI concerns (navigation, error display)
- ✅ Emits states for UI
- ✅ Uses Domain entities

---

### Step 11: Presentation Layer - UI

**Purpose:** User interface

**File:** `lib/features/auth/presentation/pages/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle state changes (navigation, etc.)
        },
        builder: (context, state) {
          return Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: state.loginStatus == StateStatus.loading
                    ? null
                    : () {
                        context.read<AuthCubit>().loginUser(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                child: state.loginStatus == StateStatus.loading
                    ? CircularProgressIndicator()
                    : Text('Login'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

**Key Points:**
- ✅ Uses Cubit for state
- ✅ No business logic
- ✅ Only UI concerns

---

## 🔄 Complete Data Flow

```
1. User clicks Login button
   ↓
2. LoginScreen calls AuthCubit.loginUser()
   ↓
3. AuthCubit calls LoginUseCase.call(params)
   ↓
4. LoginUseCase calls AuthRepository.loginUser()
   ↓
5. AuthRepositoryImpl calls AuthRemoteDataSource.login()
   ↓
6. AuthRemoteDataSourceImpl makes HTTP request via ApiClient
   ↓
7. API returns JSON response
   ↓
8. JSON → LoginResponse (Model)
   ↓
9. LoginMapper.toEntity() → LoginEntity
   ↓
10. Either<ErrorMsg, LoginEntity> flows back
   ↓
11. AuthCubit handles result, emits state
   ↓
12. UI updates based on state
```

---

## 📝 Code Snippets Reference

### Base Use Case

```dart
// lib/core/use_case/base_use_case.dart
abstract class UseCase<T, Params> {
  Future<Either<ErrorMsg, T>> call(Params params);
}
```

### Either Type (Error Handling)

```dart
// lib/core/functional/either.dart
typedef Either<L, R> = _Either<L, R>;

// Left = Error, Right = Success
final result = await useCase.call(params);
result.fold(
  (error) => print('Error: $error'),
  (data) => print('Success: $data'),
);
```

### Dependency Injection

```dart
// lib/core/di/dependency_injection.dart
final GetIt sl = GetIt.instance;

// Register
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
);

// Use
final repository = sl<AuthRepository>();
```

---

## ✅ Best Practices

### 1. **Domain Layer**
- ✅ Pure Dart classes only
- ✅ No Flutter dependencies
- ✅ No HTTP/database dependencies
- ✅ Use Equatable for entities
- ✅ One use case = one operation

### 2. **Data Layer**
- ✅ Models match API structure
- ✅ Mappers convert Model → Entity
- ✅ Repository implements Domain interface
- ✅ Handle errors, convert to Either

### 3. **Presentation Layer**
- ✅ Use Use Cases, not Repositories directly
- ✅ Handle UI concerns only
- ✅ Use immutable state (Freezed)
- ✅ No business logic in UI

### 4. **Error Handling**
- ✅ Use `Either<ErrorMsg, T>` pattern
- ✅ Convert exceptions to ErrorMsg
- ✅ Handle errors at each layer
- ✅ Show user-friendly messages

---

## 🎯 Common Patterns

### Pattern 1: Use Case with Parameters

```dart
class GetUserUseCase extends UseCase<UserEntity, GetUserParams> {
  final UserRepository repository;
  
  GetUserUseCase(this.repository);
  
  @override
  Future<Either<ErrorMsg, UserEntity>> call(GetUserParams params) async {
    return await repository.getUser(params.userId);
  }
}

class GetUserParams extends Equatable {
  final String userId;
  const GetUserParams({required this.userId});
  
  @override
  List<Object?> get props => [userId];
}
```

### Pattern 2: Use Case without Parameters

```dart
class GetProductsUseCase extends UseCaseNoParams<List<ProductEntity>> {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  @override
  Future<Either<ErrorMsg, List<ProductEntity>>> call() async {
    return await repository.getProducts();
  }
}
```

### Pattern 3: Repository with Multiple Data Sources

```dart
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  
  @override
  Future<Either<ErrorMsg, List<ProductEntity>>> getProducts() async {
    try {
      // Try remote first
      final remoteProducts = await remoteDataSource.getProducts();
      // Cache locally
      await localDataSource.cacheProducts(remoteProducts);
      return Right(remoteProducts.map((m) => ProductMapper.toEntity(m)).toList());
    } catch (e) {
      // Fallback to local cache
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts.map((m) => ProductMapper.toEntity(m)).toList());
      } catch (e) {
        return Left('Failed to load products');
      }
    }
  }
}
```

---

## 🧪 Testing Strategy

### Test Use Case

```dart
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(authRepository: mockRepository);
  });

  test('should return LoginEntity when login succeeds', () async {
    // Arrange
    final params = LoginParams(email: 'test@test.com', password: 'password');
    final entity = LoginEntity(token: 'token', userId: '1', email: 'test@test.com');
    when(mockRepository.loginUser(params: params))
        .thenAnswer((_) async => Right(entity));

    // Act
    final result = await useCase.call(params);

    // Assert
    expect(result, Right(entity));
    verify(mockRepository.loginUser(params: params));
  });
}
```

### Test Repository

```dart
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(mockDataSource);
  });

  test('should return LoginEntity when data source succeeds', () async {
    // Arrange
    final params = LoginParams(email: 'test@test.com', password: 'password');
    final model = LoginResponse(token: 'token', userId: '1', email: 'test@test.com');
    when(mockDataSource.login(params: params))
        .thenAnswer((_) async => model);

    // Act
    final result = await repository.loginUser(params: params);

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (error) => fail('Should not return error'),
      (entity) {
        expect(entity.token, 'token');
        expect(entity.userId, '1');
      },
    );
  });
}
```

---

## 📚 Summary

### Key Takeaways

1. **Domain Layer** = Business logic, pure Dart
2. **Data Layer** = Implementation, external data
3. **Presentation Layer** = UI, state management
4. **Dependencies point inward** → Domain
5. **Use interfaces** for abstraction
6. **Either pattern** for error handling
7. **Test each layer** independently

### File Structure Template

```
features/[feature]/
├── domain/
│   ├── entities/
│   │   └── [feature]_entity.dart
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   └── use_cases/
│       └── [action]_use_case.dart
├── data/
│   ├── data_sources/
│   │   └── [feature]_remote_data_source_impl.dart
│   ├── models/
│   │   └── [feature]_model.dart
│   ├── mappers/
│   │   └── [feature]_mapper.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── [feature]_cubit.dart
    │   └── [feature]_state.dart
    └── pages/
        └── [feature]_page.dart
```

---

**Happy Coding! 🚀**

For more examples, check the `auth` and `products` features in this project.
