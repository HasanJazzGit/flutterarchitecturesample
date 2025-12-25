# ⚡ Clean Architecture - Quick Reference

Quick code snippets and templates for implementing Clean Architecture.

---

## 📋 Quick Templates

### 1. Entity Template

```dart
import 'package:equatable/equatable.dart';

class [Feature]Entity extends Equatable {
  final String id;
  final String name;
  // Add more fields

  const [Feature]Entity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
```

### 2. Repository Interface Template

```dart
import '../../../../core/functional/functional_export.dart';
import '../entities/[feature]_entity.dart';

abstract class [Feature]Repository {
  Future<Either<ErrorMsg, [Feature]Entity>> get[Feature](String id);
  Future<Either<ErrorMsg, List<[Feature]Entity>>> getAll[Features]();
  Future<Either<ErrorMsg, [Feature]Entity>> create[Feature]([Feature]Entity entity);
}
```

### 3. Use Case Template

```dart
import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/[feature]_entity.dart';
import '../repositories/[feature]_repository.dart';

class Get[Feature]UseCase extends UseCase<[Feature]Entity, Get[Feature]Params> {
  final [Feature]Repository repository;

  Get[Feature]UseCase(this.repository);

  @override
  Future<Either<ErrorMsg, [Feature]Entity>> call(Get[Feature]Params params) async {
    return await repository.get[Feature](params.id);
  }
}

class Get[Feature]Params extends Equatable {
  final String id;
  const Get[Feature]Params({required this.id});
  
  @override
  List<Object?> get props => [id];
}
```

### 4. Model Template

```dart
class [Feature]Model {
  final String id;
  final String name;

  [Feature]Model({
    required this.id,
    required this.name,
  });

  factory [Feature]Model.fromJson(Map<String, dynamic> json) {
    return [Feature]Model(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

### 5. Mapper Template

```dart
import '../../domain/entities/[feature]_entity.dart';
import '../models/[feature]_model.dart';

class [Feature]Mapper {
  static [Feature]Entity toEntity([Feature]Model model) {
    return [Feature]Entity(
      id: model.id,
      name: model.name,
    );
  }

  static [Feature]Model toModel([Feature]Entity entity) {
    return [Feature]Model(
      id: entity.id,
      name: entity.name,
    );
  }
}
```

### 6. Data Source Template

```dart
// Interface
abstract class [Feature]RemoteDataSource {
  Future<[Feature]Model> get[Feature](String id);
}

// Implementation
class [Feature]RemoteDataSourceImpl implements [Feature]RemoteDataSource {
  final ApiClient apiClient;

  [Feature]RemoteDataSourceImpl(this.apiClient);

  @override
  Future<[Feature]Model> get[Feature](String id) async {
    final response = await apiClient.get('${AppUrls.[feature]}/$id');
    return [Feature]Model.fromJson(response);
  }
}
```

### 7. Repository Implementation Template

```dart
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/[feature]_entity.dart';
import '../../domain/repositories/[feature]_repository.dart';
import '../data_sources/[feature]_remote_data_source.dart';
import '../mappers/[feature]_mapper.dart';

class [Feature]RepositoryImpl implements [Feature]Repository {
  final [Feature]RemoteDataSource remoteDataSource;

  [Feature]RepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorMsg, [Feature]Entity>> get[Feature](String id) async {
    try {
      final model = await remoteDataSource.get[Feature](id);
      final entity = [Feature]Mapper.toEntity(model);
      return Right(entity);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
```

### 8. State Template (Freezed)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/enums/state_status.dart';
import '../../domain/entities/[feature]_entity.dart';

part '[feature]_state.freezed.dart';

@freezed
class [Feature]State with _$[Feature]State {
  const factory [Feature]State({
    @Default(StateStatus.initial) StateStatus status,
    List<[Feature]Entity>? [features],
    String? errorMessage,
  }) = _[Feature]State;
}
```

### 9. Cubit Template

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/state_status.dart';
import '../../domain/use_cases/get_[feature]_use_case.dart';
import '[feature]_state.dart';

class [Feature]Cubit extends Cubit<[Feature]State> {
  final Get[Feature]UseCase get[Feature]UseCase;

  [Feature]Cubit(this.get[Feature]UseCase) : super(const [Feature]State());

  Future<void> load[Features]() async {
    emit(state.copyWith(status: StateStatus.loading));

    final result = await get[Feature]UseCase.call();

    result.fold(
      (error) => emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: error,
      )),
      ([features]) => emit(state.copyWith(
        status: StateStatus.success,
        [features]: [features],
      )),
    );
  }
}
```

### 10. Dependency Injection Template

```dart
// Feature injection file: [feature]_injection.dart
import 'package:get_it/get_it.dart';
import '../../core/di/dependency_injection.dart';
import 'data/data_sources/[feature]_remote_data_source_impl.dart';
import 'data/repositories/[feature]_repository_impl.dart';
import 'domain/repositories/[feature]_repository.dart';
import 'domain/use_cases/get_[feature]_use_case.dart';
import 'presentation/cubit/[feature]_cubit.dart';

void init[Feature]Injector() {
  // Data Sources
  sl.registerLazySingleton<[Feature]RemoteDataSource>(
    () => [Feature]RemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<[Feature]Repository>(
    () => [Feature]RepositoryImpl(sl<[Feature]RemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<Get[Feature]UseCase>(
    () => Get[Feature]UseCase(sl<[Feature]Repository>()),
  );

  // Cubits
  sl.registerLazySingleton<[Feature]Cubit>(
    () => [Feature]Cubit(sl<Get[Feature]UseCase>()),
  );
}
```

---

## 🔄 Common Patterns

### Pattern 1: List Use Case

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

### Pattern 2: Create Use Case

```dart
class CreateProductUseCase extends UseCase<ProductEntity, CreateProductParams> {
  final ProductRepository repository;
  
  CreateProductUseCase(this.repository);
  
  @override
  Future<Either<ErrorMsg, ProductEntity>> call(CreateProductParams params) async {
    // Validation
    if (params.name.isEmpty) {
      return Left('Product name cannot be empty');
    }
    
    return await repository.createProduct(params);
  }
}
```

### Pattern 3: Error Handling in Repository

```dart
@override
Future<Either<ErrorMsg, ProductEntity>> getProduct(String id) async {
  try {
    final model = await remoteDataSource.getProduct(id);
    final entity = ProductMapper.toEntity(model);
    return Right(entity);
  } on ApiException catch (e) {
    return Left(e.message);
  } on NetworkException catch (e) {
    return Left('Network error: ${e.message}');
  } catch (e) {
    return Left('Unexpected error: ${e.toString()}');
  }
}
```

### Pattern 4: Cubit with Loading States

```dart
Future<void> loadData() async {
  emit(state.copyWith(status: StateStatus.loading));
  
  final result = await useCase.call();
  
  result.fold(
    (error) => emit(state.copyWith(
      status: StateStatus.error,
      errorMessage: error,
    )),
    (data) => emit(state.copyWith(
      status: StateStatus.success,
      data: data,
    )),
  );
}
```

---

## 📁 File Naming Conventions

| Component | Naming Pattern | Example |
|-----------|---------------|---------|
| Entity | `[feature]_entity.dart` | `product_entity.dart` |
| Repository Interface | `[feature]_repository.dart` | `product_repository.dart` |
| Repository Impl | `[feature]_repository_impl.dart` | `product_repository_impl.dart` |
| Use Case | `[action]_[feature]_use_case.dart` | `get_product_use_case.dart` |
| Params | `[action]_[feature]_params.dart` | `get_product_params.dart` |
| Model | `[feature]_model.dart` | `product_model.dart` |
| Mapper | `[feature]_mapper.dart` | `product_mapper.dart` |
| Data Source | `[feature]_remote_data_source.dart` | `product_remote_data_source.dart` |
| State | `[feature]_state.dart` | `product_state.dart` |
| Cubit | `[feature]_cubit.dart` | `product_cubit.dart` |
| Page | `[feature]_page.dart` | `product_page.dart` |

---

## ✅ Checklist for New Feature

- [ ] Create domain entity
- [ ] Create repository interface
- [ ] Create use case(s)
- [ ] Create data model
- [ ] Create mapper
- [ ] Create data source interface
- [ ] Create data source implementation
- [ ] Create repository implementation
- [ ] Create state (Freezed)
- [ ] Create cubit
- [ ] Create UI page
- [ ] Set up dependency injection
- [ ] Add routes
- [ ] Test each layer

---

## 🎯 Key Rules

1. **Domain** = Pure Dart, no dependencies
2. **Data** = Implements Domain interfaces
3. **Presentation** = Uses Use Cases only
4. **Dependencies point inward** → Domain
5. **Use Either** for error handling
6. **Test independently** each layer

---

**Quick Start:** Copy templates above and replace `[Feature]` with your feature name!
