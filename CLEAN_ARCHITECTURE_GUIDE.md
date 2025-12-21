# Clean Architecture Guide: Adding New Features

## 📋 Table of Contents

1. [When to Add a New Feature](#when-to-add-a-new-feature)
2. [Advantages of Clean Architecture](#advantages-of-clean-architecture)
3. [Feature Structure Overview](#feature-structure-overview)
4. [Step-by-Step Guide](#step-by-step-guide)
5. [Complete Example](#complete-example)
6. [Best Practices](#best-practices)

---

## 🎯 When to Add a New Feature

### Add a New Feature When:

1. **New Business Logic**: You need to implement a new business operation (e.g., user registration, product search, order placement)
2. **New Data Source**: You need to fetch or save data from a new API endpoint or local database
3. **Independent Functionality**: The feature is independent enough to be separated (e.g., authentication, products, orders, profile)
4. **Reusable Logic**: The logic might be reused across different parts of the app

### Don't Create a New Feature For:

- Simple UI components (use widgets)
- Utility functions (use core/utils)
- Constants (use core/constants)
- Simple state management (use existing cubits)

---

## ✨ Advantages of Clean Architecture

### 1. **Separation of Concerns**
- Each layer has a single responsibility
- Easy to understand and maintain
- Changes in one layer don't affect others

### 2. **Testability**
- Each layer can be tested independently
- Easy to mock dependencies
- High test coverage possible

### 3. **Flexibility**
- Easy to swap implementations (e.g., change API client)
- Easy to add new data sources (local/remote)
- Easy to modify business logic

### 4. **Scalability**
- Easy to add new features
- Easy to modify existing features
- Team can work on different features independently

### 5. **Maintainability**
- Clear structure and organization
- Easy to find and fix bugs
- Easy to add new developers to the project

### 6. **Independence**
- Business logic is independent of UI
- Business logic is independent of data sources
- Can change UI or data sources without affecting business logic

---

## 📁 Feature Structure Overview

```
lib/features/[feature_name]/
├── data/                          # Data Layer (External)
│   ├── data_sources/             # Data Sources (Remote/Local)
│   │   ├── [feature]_remote_data_source.dart          # Abstract
│   │   ├── [feature]_remote_data_source_impl.dart    # Implementation
│   │   ├── [feature]_local_data_source.dart           # Abstract (if needed)
│   │   └── [feature]_local_data_source_impl.dart      # Implementation (if needed)
│   ├── models/                    # Data Models (API Response)
│   │   └── [feature]_model.dart
│   ├── mappers/                   # Model to Entity Mappers
│   │   └── [feature]_mapper.dart
│   └── repositories/              # Repository Implementation
│       └── [feature]_repository_impl.dart
│
├── domain/                        # Domain Layer (Business Logic)
│   ├── entities/                  # Business Entities
│   │   └── [feature]_entity.dart
│   ├── repositories/              # Repository Interface
│   │   └── [feature]_repository.dart
│   └── use_cases/                 # Use Cases (Business Logic)
│       ├── [action]_use_case.dart
│       └── [action]_params.dart
│
├── presentation/                  # Presentation Layer (UI)
│   ├── manager/                    # State Management (Cubit/BLoC)
│   │   ├── [feature]_cubit.dart
│   │   └── [feature]_state.dart
│   ├── pages/                      # UI Pages
│   │   └── [feature]_page.dart
│   └── widgets/                    # Reusable Widgets
│       └── [feature]_widget.dart
│
└── [feature]_injection.dart       # Dependency Injection
```

---

## 🚀 Step-by-Step Guide

### Step 1: Create Feature Directory Structure

```bash
mkdir -p lib/features/[feature_name]/data/data_sources
mkdir -p lib/features/[feature_name]/data/models
mkdir -p lib/features/[feature_name]/data/mappers
mkdir -p lib/features/[feature_name]/data/repositories
mkdir -p lib/features/[feature_name]/domain/entities
mkdir -p lib/features/[feature_name]/domain/repositories
mkdir -p lib/features/[feature_name]/domain/use_cases
mkdir -p lib/features/[feature_name]/presentation/pages
mkdir -p lib/features/[feature_name]/presentation/widgets
```

**Example:** For a "users" feature:
```bash
mkdir -p lib/features/users/data/data_sources
mkdir -p lib/features/users/data/models
# ... etc
```

---

### Step 2: Create Domain Entity

**Location:** `lib/features/[feature_name]/domain/entities/[feature]_entity.dart`

**Purpose:** Represents business data (pure Dart class, no dependencies)

**Rules:**
- Use `Equatable` for value equality
- No dependencies on external packages (except equatable)
- Represents business concepts, not API structure

**Example:**

```dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, createdAt];
}
```

---

### Step 3: Create Data Model

**Location:** `lib/features/[feature_name]/data/models/[feature]_model.dart`

**Purpose:** Represents API response structure (JSON serializable)

**Rules:**
- Matches API response structure
- Has `fromJson` and `toJson` methods
- Can extend Entity if structure matches

**Example:**

```dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert to Entity (if Model doesn't extend Entity)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }
}
```

---

### Step 4: Create Mapper

**Location:** `lib/features/[feature_name]/data/mappers/[feature]_mapper.dart`

**Purpose:** Converts Model to Entity (if Model doesn't extend Entity)

**Rules:**
- Static methods
- Handles null values safely
- Transforms data types if needed

**Example:**

```dart
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserMapper {
  /// Convert UserModel to UserEntity
  static UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      avatarUrl: model.avatarUrl,
      createdAt: model.createdAt,
    );
  }

  /// Convert list of UserModel to list of UserEntity
  static List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }
}
```

**Note:** If Model extends Entity, you can skip the mapper and use `model.toEntity()` directly.

---

### Step 5: Create Remote Data Source (Abstract)

**Location:** `lib/features/[feature_name]/data/data_sources/[feature]_remote_data_source.dart`

**Purpose:** Defines contract for remote data operations

**Rules:**
- Abstract class
- Methods return raw data (Models or JSON)
- No business logic

**Example:**

```dart
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  /// Get user by ID
  Future<UserModel> getUserById(String userId);

  /// Get all users
  Future<List<UserModel>> getUsers({int? page, int? limit});

  /// Create new user
  Future<UserModel> createUser({
    required String name,
    required String email,
  });

  /// Update user
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? email,
  });

  /// Delete user
  Future<void> deleteUser(String userId);
}
```

---

### Step 6: Create Remote Data Source Implementation

**Location:** `lib/features/[feature_name]/data/data_sources/[feature]_remote_data_source_impl.dart`

**Purpose:** Implements remote data source using ApiClient

**Rules:**
- Implements abstract data source
- Uses `ApiClient` for HTTP requests
- Handles API exceptions
- Returns Models

**Example:**

```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_client.dart' show ApiException;
import '../../../../core/network/app_urls.dart';
import '../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await apiClient.get(
        '${AppUrls.users}/$userId',
      );

      return UserModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<List<UserModel>> getUsers({int? page, int? limit}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await apiClient.get(
        AppUrls.users,
        queryParameters: queryParams,
      );

      // Handle list response
      final List<dynamic> usersJson = response['users'] as List<dynamic>? ?? 
                                      response['data'] as List<dynamic>? ?? 
                                      [];

      return usersJson
          .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> createUser({
    required String name,
    required String email,
  }) async {
    try {
      final response = await apiClient.post(
        AppUrls.users,
        body: {
          'name': name,
          'email': email,
        },
      );

      return UserModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;

      final response = await apiClient.put(
        '${AppUrls.users}/$userId',
        body: body,
      );

      return UserModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await apiClient.delete('${AppUrls.users}/$userId');
    } on ApiException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete user: ${e.toString()}');
    }
  }
}
```

---

### Step 7: Create Local Data Source (If Needed)

**Location:** `lib/features/[feature_name]/data/data_sources/[feature]_local_data_source.dart`

**Purpose:** Defines contract for local data operations (cache, database)

**When to Use:**
- Need offline data access
- Need to cache API responses
- Need complex local data storage

**Example:**

```dart
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  /// Get cached user by ID
  Future<UserModel?> getUserById(String userId);

  /// Get all cached users
  Future<List<UserModel>> getUsers();

  /// Cache user
  Future<void> cacheUser(UserModel user);

  /// Cache multiple users
  Future<void> cacheUsers(List<UserModel> users);

  /// Clear cache
  Future<void> clearCache();
}
```

**Implementation Example (using SharedPreferences or Hive):**

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences prefs;
  static const String _usersKey = 'cached_users';

  UserLocalDataSourceImpl(this.prefs);

  @override
  Future<UserModel?> getUserById(String userId) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];

    final List<dynamic> decoded = json.decode(usersJson);
    return decoded
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final users = await getUsers();
    users.removeWhere((u) => u.id == user.id);
    users.add(user);
    await cacheUsers(users);
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final usersJson = json.encode(
      users.map((user) => user.toJson()).toList(),
    );
    await prefs.setString(_usersKey, usersJson);
  }

  @override
  Future<void> clearCache() async {
    await prefs.remove(_usersKey);
  }
}
```

---

### Step 8: Create Repository Interface (Domain)

**Location:** `lib/features/[feature_name]/domain/repositories/[feature]_repository.dart`

**Purpose:** Defines contract for data operations (business level)

**Rules:**
- Abstract class
- Returns `Either<ErrorMsg, T>` for error handling
- Uses Entities, not Models
- Business-oriented method names

**Example:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/user_entity.dart';
import '../use_cases/get_user_use_case.dart';
import '../use_cases/create_user_use_case.dart';

abstract class UserRepository {
  /// Get user by ID
  Future<Either<ErrorMsg, UserEntity>> getUserById({
    required GetUserParams params,
  });

  /// Get all users
  Future<Either<ErrorMsg, List<UserEntity>>> getUsers({
    required GetUsersParams params,
  });

  /// Create new user
  Future<Either<ErrorMsg, UserEntity>> createUser({
    required CreateUserParams params,
  });

  /// Update user
  Future<Either<ErrorMsg, UserEntity>> updateUser({
    required UpdateUserParams params,
  });

  /// Delete user
  Future<Either<ErrorMsg, void>> deleteUser({
    required DeleteUserParams params,
  });
}
```

---

### Step 9: Create Repository Implementation

**Location:** `lib/features/[feature_name]/data/repositories/[feature]_repository_impl.dart`

**Purpose:** Implements repository, coordinates data sources, converts Models to Entities

**Rules:**
- Implements repository interface
- Uses data sources (remote/local)
- Converts Models to Entities using Mapper
- Handles errors and returns `Either<ErrorMsg, T>`
- Can implement caching strategy (remote first, local fallback)

**Example (Remote Only):**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart' show ApiException;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/use_cases/get_user_use_case.dart';
import '../../domain/use_cases/create_user_use_case.dart';
import '../data_sources/user_remote_data_source.dart';
import '../mappers/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorMsg, UserEntity>> getUserById({
    required GetUserParams params,
  }) async {
    try {
      final model = await remoteDataSource.getUserById(params.userId);
      final entity = UserMapper.toEntity(model);
      return Right(entity);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<Either<ErrorMsg, List<UserEntity>>> getUsers({
    required GetUsersParams params,
  }) async {
    try {
      final models = await remoteDataSource.getUsers(
        page: params.page,
        limit: params.limit,
      );
      final entities = UserMapper.toEntityList(models);
      return Right(entities);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get users: ${e.toString()}');
    }
  }

  @override
  Future<Either<ErrorMsg, UserEntity>> createUser({
    required CreateUserParams params,
  }) async {
    try {
      final model = await remoteDataSource.createUser(
        name: params.name,
        email: params.email,
      );
      final entity = UserMapper.toEntity(model);
      return Right(entity);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<Either<ErrorMsg, UserEntity>> updateUser({
    required UpdateUserParams params,
  }) async {
    try {
      final model = await remoteDataSource.updateUser(
        userId: params.userId,
        name: params.name,
        email: params.email,
      );
      final entity = UserMapper.toEntity(model);
      return Right(entity);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<Either<ErrorMsg, void>> deleteUser({
    required DeleteUserParams params,
  }) async {
    try {
      await remoteDataSource.deleteUser(params.userId);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to delete user: ${e.toString()}');
    }
  }
}
```

**Example (With Local Cache - Remote First, Local Fallback):**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart' show ApiException;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/use_cases/get_user_use_case.dart';
import '../data_sources/user_remote_data_source.dart';
import '../data_sources/user_local_data_source.dart';
import '../mappers/user_mapper.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource? localDataSource; // Optional

  UserRepositoryImpl(
    this.remoteDataSource, {
    this.localDataSource,
  });

  @override
  Future<Either<ErrorMsg, UserEntity>> getUserById({
    required GetUserParams params,
  }) async {
    try {
      // Try remote first
      final model = await remoteDataSource.getUserById(params.userId);
      final entity = UserMapper.toEntity(model);

      // Cache locally if available
      if (localDataSource != null) {
        await localDataSource!.cacheUser(model);
      }

      return Right(entity);
    } on ApiException catch (e) {
      // If remote fails, try local cache
      if (localDataSource != null) {
        try {
          final cachedModel = await localDataSource!.getUserById(params.userId);
          if (cachedModel != null) {
            final entity = UserMapper.toEntity(cachedModel);
            return Right(entity);
          }
        } catch (_) {
          // Local also failed
        }
      }
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get user: ${e.toString()}');
    }
  }

  // ... other methods
}
```

---

### Step 10: Create Use Case Params

**Location:** `lib/features/[feature_name]/domain/use_cases/[action]_params.dart` (or in same file as use case)

**Purpose:** Parameters for use case execution

**Rules:**
- Extends `Equatable` for value equality
- Immutable (final fields)
- Clear, descriptive names

**Example:**

```dart
import 'package:equatable/equatable.dart';

class GetUserParams extends Equatable {
  final String userId;

  const GetUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetUsersParams extends Equatable {
  final int? page;
  final int? limit;

  const GetUsersParams({this.page, this.limit});

  @override
  List<Object?> get props => [page, limit];
}

class CreateUserParams extends Equatable {
  final String name;
  final String email;

  const CreateUserParams({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, email];
}

class UpdateUserParams extends Equatable {
  final String userId;
  final String? name;
  final String? email;

  const UpdateUserParams({
    required this.userId,
    this.name,
    this.email,
  });

  @override
  List<Object?> get props => [userId, name, email];
}

class DeleteUserParams extends Equatable {
  final String userId;

  const DeleteUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
```

---

### Step 11: Create Use Case

**Location:** `lib/features/[feature_name]/domain/use_cases/[action]_use_case.dart`

**Purpose:** Encapsulates business logic for a specific action

**Rules:**
- Extends `UseCase<ReturnType, ParamsType>`
- Single responsibility (one use case = one action)
- Returns `Either<ErrorMsg, T>`
- Uses repository, not data sources directly
- No UI dependencies

**Example:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';
import 'get_user_use_case.dart'; // For GetUserParams
import 'create_user_use_case.dart'; // For CreateUserParams

/// Use case to get user by ID
class GetUserUseCase extends UseCase<UserEntity, GetUserParams> {
  final UserRepository userRepository;

  GetUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, UserEntity>> call(GetUserParams params) async {
    return await userRepository.getUserById(params: params);
  }
}

/// Use case to get all users
class GetUsersUseCase extends UseCase<List<UserEntity>, GetUsersParams> {
  final UserRepository userRepository;

  GetUsersUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, List<UserEntity>>> call(
    GetUsersParams params,
  ) async {
    return await userRepository.getUsers(params: params);
  }
}

/// Use case to create user
class CreateUserUseCase extends UseCase<UserEntity, CreateUserParams> {
  final UserRepository userRepository;

  CreateUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, UserEntity>> call(
    CreateUserParams params,
  ) async {
    // Business logic validation (optional)
    if (params.name.isEmpty) {
      return const Left('Name cannot be empty');
    }
    if (!params.email.contains('@')) {
      return const Left('Invalid email format');
    }

    return await userRepository.createUser(params: params);
  }
}

/// Use case to update user
class UpdateUserUseCase extends UseCase<UserEntity, UpdateUserParams> {
  final UserRepository userRepository;

  UpdateUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, UserEntity>> call(
    UpdateUserParams params,
  ) async {
    return await userRepository.updateUser(params: params);
  }
}

/// Use case to delete user
class DeleteUserUseCase extends UseCase<void, DeleteUserParams> {
  final UserRepository userRepository;

  DeleteUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, void>> call(DeleteUserParams params) async {
    return await userRepository.deleteUser(params: params);
  }
}
```

**Use Case Without Parameters:**

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case with no parameters
class GetCurrentUserUseCase extends UseCaseNoParams<UserEntity> {
  final UserRepository userRepository;

  GetCurrentUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, UserEntity>> call() async {
    // Get current user from storage or repository
    // Implementation depends on your app
    return await userRepository.getCurrentUser();
  }
}
```

---

### Step 12: Create Dependency Injection File

**Location:** `lib/features/[feature_name]/[feature]_injection.dart`

**Purpose:** Registers all feature dependencies in GetIt

**Rules:**
- Register in order: Data Sources → Repositories → Use Cases
- Use `registerLazySingleton` for services
- Use `registerFactory` for Cubits (if needed)

**Example (Without Cubit):**

```dart
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/user_remote_data_source.dart';
import 'data/data_sources/user_remote_data_source_impl.dart';
import 'data/data_sources/user_local_data_source.dart';
import 'data/data_sources/user_local_data_source_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/get_user_use_case.dart';
import 'domain/use_cases/get_users_use_case.dart';
import 'domain/use_cases/create_user_use_case.dart';
import 'domain/use_cases/update_user_use_case.dart';
import 'domain/use_cases/delete_user_use_case.dart';

/// Initialize user feature dependencies
void initUserInjector() {
  // Register Remote Data Source
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Local Data Source (if needed)
  // Uncomment if using local data source
  // sl.registerLazySingleton<UserLocalDataSource>(
  //   () => UserLocalDataSourceImpl(sl<SharedPreferences>()),
  // );

  // Register Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      sl<UserRemoteDataSource>(),
      // localDataSource: sl<UserLocalDataSource>(), // If using local
    ),
  );

  // Register Use Cases
  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(userRepository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(userRepository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(userRepository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(userRepository: sl<UserRepository>()),
  );

  sl.registerLazySingleton<DeleteUserUseCase>(
    () => DeleteUserUseCase(userRepository: sl<UserRepository>()),
  );

  // Note: Cubits are registered as Factory (if needed)
  // sl.registerFactory<UserCubit>(
  //   () => UserCubit(
  //     getUserUseCase: sl<GetUserUseCase>(),
  //     createUserUseCase: sl<CreateUserUseCase>(),
  //   ),
  // );
}
```

---

### Step 13: Register in Main DI File

**Location:** `lib/core/di/dependency_injection.dart`

**Add your feature injection:**

```dart
import '../../features/user/user_injection.dart'; // Add import

Future<void> initDependencyInjection() async {
  await _initCore();

  // Initialize feature dependencies
  initAuthInjector();
  initProductsInjector();
  initUserInjector(); // Add this line
  // Add more features here
}
```

---

### Step 14: Add API URLs (If Needed)

**Location:** `lib/core/network/app_urls.dart`

**Add your feature endpoints:**

```dart
class AppUrls {
  // ... existing URLs

  // User endpoints
  static const String users = '/users';
  static const String userById = '/users/:id';
}
```

---

## 📝 Complete Example: User Feature

Here's a complete example of a "User" feature with all layers:

### 1. Entity (`domain/entities/user_entity.dart`)
```dart
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl, createdAt];
}
```

### 2. Model (`data/models/user_model.dart`)
```dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

### 3. Remote Data Source (`data/data_sources/user_remote_data_source.dart`)
```dart
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<List<UserModel>> getUsers({int? page, int? limit});
  Future<UserModel> createUser({required String name, required String email});
}
```

### 4. Remote Data Source Impl (`data/data_sources/user_remote_data_source_impl.dart`)
```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_client.dart' show ApiException;
import '../../../../core/network/app_urls.dart';
import '../models/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl(this.apiClient);

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await apiClient.get('${AppUrls.users}/$userId');
      return UserModel.fromJson(response);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  // ... other methods
}
```

### 5. Repository Interface (`domain/repositories/user_repository.dart`)
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../entities/user_entity.dart';
import '../use_cases/get_user_use_case.dart';

abstract class UserRepository {
  Future<Either<ErrorMsg, UserEntity>> getUserById({
    required GetUserParams params,
  });
}
```

### 6. Repository Impl (`data/repositories/user_repository_impl.dart`)
```dart
import 'package:dartz/dartz.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/network/api_client.dart' show ApiException;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/use_cases/get_user_use_case.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorMsg, UserEntity>> getUserById({
    required GetUserParams params,
  }) async {
    try {
      final model = await remoteDataSource.getUserById(params.userId);
      return Right(model); // Model extends Entity, so can return directly
    } on ApiException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to get user: ${e.toString()}');
    }
  }
}
```

### 7. Use Case (`domain/use_cases/get_user_use_case.dart`)
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/failure/exceptions.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase extends UseCase<UserEntity, GetUserParams> {
  final UserRepository userRepository;

  GetUserUseCase({required this.userRepository});

  @override
  Future<Either<ErrorMsg, UserEntity>> call(GetUserParams params) async {
    return await userRepository.getUserById(params: params);
  }
}

class GetUserParams extends Equatable {
  final String userId;

  const GetUserParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
```

### 8. Dependency Injection (`user_injection.dart`)
```dart
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/user_remote_data_source.dart';
import 'data/data_sources/user_remote_data_source_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/use_cases/get_user_use_case.dart';

void initUserInjector() {
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(sl<ApiClient>()),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(userRepository: sl<UserRepository>()),
  );
}
```

### 9. Usage Example (Without Cubit)

```dart
import 'package:flutter/material.dart';
import '../../core/di/dependency_injection.dart';
import '../../features/user/domain/use_cases/get_user_use_case.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final getUserUseCase = sl<GetUserUseCase>();
  UserEntity? user;
  String? error;
  bool isLoading = false;

  Future<void> loadUser(String userId) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final result = await getUserUseCase.call(GetUserParams(userId: userId));

    result.fold(
      // Left: Error
      (errorMsg) {
        setState(() {
          error = errorMsg;
          isLoading = false;
        });
      },
      // Right: Success
      (userEntity) {
        setState(() {
          user = userEntity;
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : user != null
                  ? Center(child: Text('User: ${user!.name}'))
                  : const Center(child: Text('No user loaded')),
    );
  }
}
```

---

## ✅ Best Practices

### 1. **Naming Conventions**
- **Entities:** `[Feature]Entity` (e.g., `UserEntity`)
- **Models:** `[Feature]Model` (e.g., `UserModel`)
- **Data Sources:** `[Feature]RemoteDataSource`, `[Feature]LocalDataSource`
- **Repositories:** `[Feature]Repository`
- **Use Cases:** `[Action][Feature]UseCase` (e.g., `GetUserUseCase`, `CreateUserUseCase`)
- **Params:** `[Action][Feature]Params` (e.g., `GetUserParams`)

### 2. **Error Handling**
- Always use `Either<ErrorMsg, T>` in repositories and use cases
- Convert exceptions to `ErrorMsg` (String) in repository implementation
- Let UI handle error display

### 3. **Dependency Injection**
- Register in order: Data Sources → Repositories → Use Cases
- Use `registerLazySingleton` for services
- Use `registerFactory` for Cubits (if needed)

### 4. **Testing**
- Test each layer independently
- Mock dependencies
- Test error cases

### 5. **File Organization**
- Keep related files together
- Use clear, descriptive names
- Follow the established structure

### 6. **Code Reusability**
- Create reusable mappers
- Create reusable params classes
- Extract common logic to utilities

---

## 🎓 Summary

### Quick Checklist:

- [ ] Create feature directory structure
- [ ] Create Domain Entity
- [ ] Create Data Model
- [ ] Create Mapper (if Model doesn't extend Entity)
- [ ] Create Remote Data Source (Abstract)
- [ ] Create Remote Data Source Implementation
- [ ] Create Local Data Source (if needed)
- [ ] Create Repository Interface (Domain)
- [ ] Create Repository Implementation
- [ ] Create Use Case Params
- [ ] Create Use Cases
- [ ] Create Dependency Injection file
- [ ] Register in main DI file
- [ ] Add API URLs (if needed)

### Flow Diagram:

```
UI/Widget
    ↓
Use Case (Business Logic)
    ↓
Repository Interface (Domain)
    ↓
Repository Implementation (Data)
    ↓
Data Source (Remote/Local)
    ↓
API Client / Local Storage
```

---

## 📚 Additional Resources

- See existing features (`auth`, `products`) for reference
- Check `DI_TEMPLATE.md` for dependency injection patterns
- Check `STORAGE.md` for local storage patterns

---

**Happy Coding! 🚀**
