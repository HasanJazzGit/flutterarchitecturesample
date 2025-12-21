# Database & DAO Implementation Guide - MVVM Feature

## Overview

This guide explains the **best practices** approach for implementing database and DAO (Data Access Object) in the MVVM feature using Drift database.

## Architecture

### Best Practice Structure

```
MVVM Feature
├── model/
│   └── models/
│       └── task_model.dart          # Data model
├── data/
│   ├── database/                     # ✅ Database Layer
│   │   └── tables/                  # ✅ Tables (Best Practice: Separate files)
│   │       └── tasks_table.dart     # Tasks table definition
│   ├── dao/                          # ✅ DAO Layer (Best Practice)
│   │   └── tasks_dao.dart           # Database operations
│   ├── data_sources/
│   │   ├── task_remote_data_source.dart
│   │   ├── task_remote_data_source_impl.dart
│   │   ├── task_local_data_source.dart      # Abstract interface
│   │   └── task_local_data_source_impl.dart # Uses DAO
│   └── repositories/
│       └── task_repository_impl.dart # Uses data sources
└── viewmodel/
    └── task_cubit.dart               # Uses repository
```

### Data Flow with DAO

```
TaskCubit (ViewModel)
    ↓
TaskRepositoryImpl
    ↓
TaskLocalDataSource (Interface)
    ↓
TaskLocalDataSourceImpl
    ↓
TasksDao (DAO) ← ✅ Best Practice: Separated database operations
    ↓
AppDatabase (Drift)
    ↓
Tasks Table
```

---

## Components

### 1. Database Table

**Location:** `lib/features/example_mvvm/data/database/tables/tasks_table.dart`

✅ **Best Practice:** Tables are placed in feature's `database/tables` folder for better modularity and organization.

```dart
/// Tasks table for MVVM example feature
/// 
/// This table stores task data for offline support.
/// Located in feature's database/tables folder for better modularity.
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()(); // Timestamp
  IntColumn get updatedAt => integer().nullable()(); // Timestamp
  TextColumn get category => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Why separate file?**
- ✅ **Modularity**: Table stays with its feature
- ✅ **Organization**: Clear database/tables structure
- ✅ **Maintainability**: Easy to find and update
- ✅ **Scalability**: Each feature manages its own tables

**Key Features:**
- Primary key on `id`
- Timestamps for sorting (createdAt, updatedAt)
- Nullable fields for optional data (category, updatedAt)
- Default value for boolean (isCompleted)

### 2. DAO (Data Access Object)

**Location:** `lib/features/example_mvvm/data/dao/tasks_dao.dart`

**Why DAO?**
- ✅ **Separation of Concerns**: Database operations separated from business logic
- ✅ **Reusability**: DAO can be used by multiple data sources
- ✅ **Testability**: Easy to mock DAO for testing
- ✅ **Type Safety**: Drift provides compile-time type checking
- ✅ **Maintainability**: All database queries in one place

**DAO Methods:**

```dart
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  // CRUD Operations
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String id);
  Future<void> insertTask(TaskModel task);
  Future<void> insertTasks(List<TaskModel> tasks);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> deleteAllTasks();
  
  // Query Operations
  Future<int> getTasksCount();
  Future<List<Task>> getTasksByCompletion(bool isCompleted);
  Future<List<Task>> getTasksByCategory(String category);
  Future<void> toggleTaskCompletion(String id);
  
  // Conversion Methods
  TaskModel toTaskModel(Task dbTask);
  List<TaskModel> toTaskModels(List<Task> dbTasks);
}
```

**Key Features:**
- Type-safe database operations
- Automatic conversion between DB entities and Models
- Query methods (filter, sort, count)
- Batch operations support

### 3. Local Data Source

**Location:** `lib/features/example_mvvm/data/data_sources/task_local_data_source_impl.dart`

Uses DAO for all database operations:

```dart
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final TasksDao tasksDao;

  TaskLocalDataSourceImpl({required AppDatabase database})
      : tasksDao = TasksDao(database);

  @override
  Future<List<TaskModel>> getTasks() async {
    final dbTasks = await tasksDao.getAllTasks();
    return tasksDao.toTaskModels(dbTasks);
  }
}
```

**Key Features:**
- Delegates to DAO
- Handles error conversion
- Converts DB entities to Models

### 4. Repository (Offline-First)

**Location:** `lib/features/example_mvvm/data/repositories/task_repository_impl.dart`

Implements offline-first strategy:

```dart
class TaskRepositoryImpl {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  Future<Either<ErrorMsg, List<TaskModel>>> getTasks() async {
    final hasInternet = await connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        // Try remote first
        final remoteTasks = await remoteDataSource.getTasks();
        // Save to local
        await localDataSource.saveTasks(remoteTasks);
        return Right(remoteTasks);
      } catch (e) {
        // Fallback to local
        return await _getTasksFromLocal();
      }
    } else {
      // No internet - get from local
      return await _getTasksFromLocal();
    }
  }
}
```

---

## Best Practices

### 1. DAO Pattern

✅ **DO:**
- Create DAO for each table/feature
- Keep DAO focused on database operations only
- Use type-safe Drift queries
- Add conversion methods (DB → Model)
- Include query methods (filter, sort, count)

❌ **DON'T:**
- Put business logic in DAO
- Access UI components from DAO
- Mix DAO with repository logic
- Skip error handling
- Forget to convert DB entities to Models

### 2. Database Schema

✅ **DO:**
- Use appropriate column types
- Add primary keys
- Use nullable for optional fields
- Add timestamps for sorting
- Set default values where appropriate
- Increment schema version on changes

❌ **DON'T:**
- Store sensitive data without encryption
- Forget primary keys
- Use wrong column types
- Skip migrations
- Store large data directly (use file paths)

### 3. Offline-First Strategy

✅ **DO:**
- Check connectivity before API calls
- Save remote data to local automatically
- Use local data as fallback
- Handle offline scenarios gracefully
- Sync data when online

❌ **DON'T:**
- Rely only on remote data
- Forget to sync local storage
- Block UI during persistence
- Show errors for offline mode
- Skip data synchronization

### 4. Error Handling

✅ **DO:**
- Wrap database operations in try-catch
- Return meaningful error messages
- Handle null cases
- Log errors for debugging
- Provide fallback mechanisms

❌ **DON'T:**
- Ignore database errors
- Expose technical errors to users
- Forget null checks
- Skip error logging

---

## Setup Steps

### 1. Create Table in Feature

**File:** `lib/features/example_mvvm/data/database/tables/tasks_table.dart`

```dart
import 'package:drift/drift.dart';

class Tasks extends Table {
  // Define columns
  TextColumn get id => text()();
  // ... other columns
}
```

### 2. Import Table in Core Database

**File:** `lib/core/database/app_database.dart`

```dart
// Import feature-specific tables
import '../../features/example_mvvm/data/database/tables/tasks_table.dart';

@DriftDatabase(tables: [Products, Tasks])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 2; // Increment version
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(tasks);
        }
      },
    );
  }
}
```

### 2. Create DAO

**File:** `lib/features/example_mvvm/data/dao/tasks_dao.dart`

```dart
@DriftAccessor(tables: [Tasks])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(AppDatabase db) : super(db);
  
  // Implement database operations
}
```

### 3. Generate Code

Run build_runner to generate DAO code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Create Local Data Source

**File:** `lib/features/example_mvvm/data/data_sources/task_local_data_source_impl.dart`

```dart
class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final TasksDao tasksDao;
  
  TaskLocalDataSourceImpl({required AppDatabase database})
      : tasksDao = TasksDao(database);
}
```

### 5. Update Repository

Add local data source and connectivity service to repository.

### 6. Update Dependency Injection

Register local data source in injection file.

---

## Usage Examples

### Using DAO Directly

```dart
final dao = TasksDao(database);

// Get all tasks
final tasks = await dao.getAllTasks();

// Insert task
await dao.insertTask(taskModel);

// Get by ID
final task = await dao.getTaskById('123');

// Update task
await dao.updateTask(taskModel);

// Delete task
await dao.deleteTask('123');
```

### Using Local Data Source

```dart
final localDataSource = TaskLocalDataSourceImpl(database: database);

// Get all tasks (returns TaskModel, not DB entity)
final tasks = await localDataSource.getTasks();

// Save task
await localDataSource.saveTask(taskModel);
```

### Using Repository (Recommended)

```dart
final repository = TaskRepositoryImpl(
  remoteDataSource: remoteDataSource,
  localDataSource: localDataSource,
  connectivityService: connectivityService,
);

// Get tasks (offline-first)
final result = await repository.getTasks();
result.fold(
  (error) => print('Error: $error'),
  (tasks) => print('Tasks: $tasks'),
);
```

---

## Advantages of DAO Pattern

1. **Separation of Concerns**
   - Database operations isolated from business logic
   - Easy to test and maintain

2. **Reusability**
   - DAO can be used by multiple data sources
   - Consistent database access

3. **Type Safety**
   - Compile-time checking
   - Auto-completion support

4. **Testability**
   - Easy to mock DAO
   - Unit test database operations

5. **Maintainability**
   - All queries in one place
   - Easy to update database schema

---

## Migration Strategy

When updating the Tasks table:

1. **Increment schema version** in `app_database.dart`
2. **Add migration logic** in `onUpgrade`:

```dart
@override
int get schemaVersion => 3; // Increment

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(tasks);
      }
      if (from < 3) {
        // Add new column
        await m.addColumn(tasks, tasks.priority);
      }
    },
  );
}
```

3. **Update Tasks table** definition
4. **Update DAO** if needed
5. **Run build_runner** to regenerate code

---

## Summary

The DAO pattern provides:

- ✅ **Clean Architecture**: Separated database operations
- ✅ **Type Safety**: Compile-time checking
- ✅ **Reusability**: Can be used by multiple sources
- ✅ **Testability**: Easy to mock and test
- ✅ **Maintainability**: All queries in one place
- ✅ **Best Practices**: Industry-standard approach

This implementation follows Flutter/Drift best practices and provides a solid foundation for database operations in your MVVM features.
