# Dependency Injection Template

## How to Add a New Feature to DI

### Step 1: Create Feature Injection File

Create `lib/features/[feature_name]/[feature_name]_injection.dart`:

```dart
import '../../core/di/dependency_injection.dart';
import '../../core/network/api_client.dart';
import 'data/data_sources/[feature]_remote_data_source.dart';
import 'data/data_sources/[feature]_remote_data_source_impl.dart';
import 'data/repositories/[feature]_repository_impl.dart';
import 'domain/repositories/[feature]_repository.dart';
import 'domain/use_cases/[use_case_1].dart';
import 'domain/use_cases/[use_case_2].dart';
import 'presentation/cubit/[feature]_cubit.dart';

/// Initialize [Feature] feature dependencies
void init[Feature]Injector() {
  // Register Data Sources (if needed)
  sl.registerLazySingleton<[Feature]RemoteDataSource>(
    () => [Feature]RemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Register Repositories
  sl.registerLazySingleton<[Feature]Repository>(
    () => [Feature]RepositoryImpl(sl<[Feature]RemoteDataSource>()),
  );

  // Register Use Cases
  sl.registerLazySingleton<[UseCase1]>(
    () => [UseCase1](repository: sl<[Feature]Repository>()),
  );

  sl.registerLazySingleton<[UseCase2]>(
    () => [UseCase2](repository: sl<[Feature]Repository>()),
  );

  // Register Cubits (Factory - creates new instance each time)
  sl.registerFactory<[Feature]Cubit>(
    () => [Feature]Cubit(
      useCase1: sl<[UseCase1]>(),
      useCase2: sl<[UseCase2]>(),
    ),
  );
}
```

### Step 2: Register in Main DI File

Add to `lib/core/di/dependency_injection.dart`:

```dart
import '../../features/[feature_name]/[feature_name]_injection.dart';

Future<void> initDependencyInjection() async {
  await _initCore();
  
  initAuthInjector();
  init[Feature]Injector(); // Add this line
  // Add more features here
}
```

### Step 3: Use in UI

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../cubit/[feature]_cubit.dart';

BlocProvider(
  create: (context) => sl<[Feature]Cubit>(),
  child: YourWidget(),
)
```

## Registration Types

- **registerLazySingleton**: Creates instance only when first accessed, then reuses it
  - Use for: Repositories, Data Sources, Use Cases, Services
  
- **registerFactory**: Creates new instance every time it's accessed
  - Use for: Cubits, BLoCs (stateful widgets need fresh instances)

- **registerSingleton**: Creates instance immediately at registration
  - Use for: Services that need immediate initialization

## Best Practices

1. Register dependencies in order: Data Sources → Repositories → Use Cases → Cubits
2. Use `sl<T>()` to resolve dependencies
3. Check if already registered: `if (!sl.isRegistered<T>())`
4. Keep feature injection files separate for better organization
5. Use factories for Cubits to ensure fresh instances per widget
