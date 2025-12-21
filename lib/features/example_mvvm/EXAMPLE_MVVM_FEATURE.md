# Example MVVM Feature - Complete Guide

## Table of Contents

1. [Overview](#overview)
2. [MVVM Architecture](#mvvm-architecture)
3. [File Structure](#file-structure)
4. [Component Details](#component-details)
5. [Data Flow](#data-flow)
6. [State Management](#state-management)
7. [UI Components](#ui-components)
8. [Usage Examples](#usage-examples)
9. [Adding New Features](#adding-new-features)
10. [Best Practices](#best-practices)
11. [MVVM vs Clean Architecture](#mvvm-vs-clean-architecture)

---

## Overview

The **Example MVVM** feature is a complete, working example demonstrating **MVVM (Model-View-ViewModel)** architecture pattern in Flutter. It implements a Task management feature with full CRUD operations following pure MVVM principles.

### What This Feature Demonstrates

- ✅ **MVVM Architecture** (Model, View, ViewModel layers)
- ✅ **Model Layer** (Data models, JSON serialization)
- ✅ **View Layer** (UI components, pages, widgets)
- ✅ **ViewModel Layer** (Business logic, state management with Cubit)
- ✅ **Data Layer** (Data sources, repositories)
- ✅ **Dependency Injection** (GetIt service locator)
- ✅ **Error Handling** (Either/Left/Right pattern)
- ✅ **CRUD Operations** (Create, Read, Update, Delete)
- ✅ **Separation of Concerns** (Clear layer boundaries)

### Features Implemented

- ✅ Create new tasks
- ✅ View all tasks
- ✅ Update existing tasks
- ✅ Delete tasks
- ✅ Toggle task completion status
- ✅ Task categories
- ✅ Pull-to-refresh
- ✅ Loading states
- ✅ Error handling
- ✅ Empty state handling

---

## MVVM Architecture

### MVVM Pattern Overview

MVVM (Model-View-ViewModel) is an architectural pattern that separates the UI (View) from business logic (ViewModel) and data (Model).

```
┌─────────────────────────────────────────┐
│              VIEW LAYER                 │
│  (UI, Widgets, User Interaction)        │
│  - TaskPage                             │
│  - TaskList Widget                      │
│  - TaskCard Widget                      │
│  - TaskFormBottomSheet                   │
└─────────────────────────────────────────┘
                    ↓ (binds to)
┌─────────────────────────────────────────┐
│          VIEWMODEL LAYER                 │
│  (Business Logic, State Management)     │
│  - TaskViewModel (Cubit)                │
│  - TaskState                            │
└─────────────────────────────────────────┘
                    ↓ (uses)
┌─────────────────────────────────────────┐
│            MODEL LAYER                   │
│  (Data Models, Business Entities)       │
│  - TaskModel                            │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            DATA LAYER                     │
│  (API, Storage, Repositories)            │
│  - TaskRemoteDataSource                 │
│  - TaskRepositoryImpl                   │
└─────────────────────────────────────────┘
```

### Key Principles

1. **Model**: Represents data and business logic (TaskModel)
2. **View**: Displays UI and handles user input (TaskPage, widgets)
3. **ViewModel**: Acts as a bridge between View and Model, manages state (TaskViewModel)
4. **Data Binding**: View observes ViewModel state changes
5. **Separation**: View doesn't directly interact with Model

### Dependency Flow

```
View (TaskPage)
    ↓ (observes state)
ViewModel (TaskViewModel)
    ↓ (uses)
Repository (TaskRepositoryImpl)
    ↓ (uses)
Data Source (TaskRemoteDataSource)
    ↓ (uses)
API Client / Storage
```

---

## File Structure

```
lib/features/example_mvvm/
├── example_mvvm_injection.dart          # Dependency Injection setup
│
├── model/                              # Model Layer
│   └── models/
│       └── task_model.dart             # Task data model
│
├── viewmodel/                          # ViewModel Layer
│   ├── task_viewmodel.dart             # ViewModel (Cubit)
│   └── task_state.dart                 # State class
│
├── view/                               # View Layer
│   ├── pages/
│   │   └── task_page.dart              # Main task page
│   └── widgets/
│       ├── task_list.dart              # List widget
│       ├── task_card.dart              # Card widget
│       └── task_form_bottom_sheet.dart # Create/Edit form
│
└── data/                               # Data Layer
    ├── data_sources/
    │   ├── task_remote_data_source.dart        # Data source interface
    │   └── task_remote_data_source_impl.dart    # API implementation
    └── repositories/
        └── task_repository_impl.dart            # Repository implementation
```

---

## Component Details

### 1. Model Layer

#### TaskModel

**Location:** `lib/features/example_mvvm/model/models/task_model.dart`

Represents task data structure.

```dart
class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? category;
}
```

**Key Features:**
- Data structure for tasks
- JSON serialization/deserialization
- Immutable (Equatable)
- `copyWith` method for updates

---

### 2. ViewModel Layer

#### TaskViewModel

**Location:** `lib/features/example_mvvm/viewmodel/task_viewmodel.dart`

Manages business logic and state. Uses Cubit for state management.

```dart
class TaskViewModel extends Cubit<TaskState> {
  final TaskRepositoryImpl repository;

  TaskViewModel({required this.repository}) : super(TaskState.initial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));
    final result = await repository.getTasks();
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (tasks) => emit(state.copyWith(tasks: tasks, isLoading: false)),
    );
  }
}
```

**Key Methods:**
- `loadTasks()` - Load all tasks
- `createTask()` - Create new task
- `updateTask()` - Update existing task
- `deleteTask()` - Delete task
- `toggleTaskCompletion()` - Toggle completion

#### TaskState

**Location:** `lib/features/example_mvvm/viewmodel/task_state.dart`

State class for ViewModel.

```dart
class TaskState extends Equatable {
  final List<TaskModel> tasks;
  final bool isLoading;
  final String? errorMessage;
}
```

---

### 3. View Layer

#### TaskPage

**Location:** `lib/features/example_mvvm/view/pages/task_page.dart`

Main page that provides ViewModel and displays UI.

```dart
class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskViewModel>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('MVVM Architecture Example')),
        body: const TaskList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => TaskFormBottomSheet.show(context),
        ),
      ),
    );
  }
}
```

#### TaskList Widget

**Location:** `lib/features/example_mvvm/view/widgets/task_list.dart`

Displays list of tasks with loading, error, and empty states.

#### TaskCard Widget

**Location:** `lib/features/example_mvvm/view/widgets/task_card.dart`

Displays individual task card with title, description, category, completion checkbox, and delete button.

#### TaskFormBottomSheet

**Location:** `lib/features/example_mvvm/view/widgets/task_form_bottom_sheet.dart`

Bottom sheet for creating/editing tasks with form validation.

---

### 4. Data Layer

#### TaskRemoteDataSource

**Location:** `lib/features/example_mvvm/data/data_sources/task_remote_data_source.dart`

Abstract interface for remote data operations.

```dart
abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask({...});
  // ... other methods
}
```

#### TaskRemoteDataSourceImpl

**Location:** `lib/features/example_mvvm/data/data_sources/task_remote_data_source_impl.dart`

Concrete implementation using ApiClient. Currently uses mock data for demonstration.

#### TaskRepositoryImpl

**Location:** `lib/features/example_mvvm/data/repositories/task_repository_impl.dart`

Repository implementation that handles data operations and error handling.

```dart
class TaskRepositoryImpl {
  final TaskRemoteDataSource remoteDataSource;

  Future<Either<ErrorMsg, List<TaskModel>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left('Failed to load tasks: ${e.toString()}');
    }
  }
}
```

---

## Data Flow

### 1. Create Task Flow

```
1. User taps FAB → TaskFormBottomSheet.show()
2. User fills form and taps "Create"
3. TaskFormBottomSheet calls TaskViewModel.createTask()
4. TaskViewModel emits loading state
5. TaskViewModel calls TaskRepositoryImpl.createTask()
6. Repository calls TaskRemoteDataSource.createTask()
7. Data source makes API call (or mock)
8. Repository receives response and returns Either
9. TaskViewModel receives result and updates state
10. View rebuilds with new task
```

### 2. Load Tasks Flow

```
1. TaskPage builds → BlocProvider creates TaskViewModel
2. TaskViewModel constructor calls loadTasks()
3. loadTasks() emits loading state
4. Calls TaskRepositoryImpl.getTasks()
5. Repository calls TaskRemoteDataSource.getTasks()
6. Data source makes API call (or mock)
7. Repository returns Either<ErrorMsg, List<TaskModel>>
8. TaskViewModel receives result and emits success/error state
9. TaskList widget rebuilds with tasks
```

### 3. Update Task Flow

```
1. User taps task card → TaskFormBottomSheet.show(task: task)
2. User edits and taps "Update"
3. TaskViewModel.updateTask() called
4. Repository → Data Source → API
5. State updated with modified task
6. UI rebuilds
```

### 4. Delete Task Flow

```
1. User taps delete icon on TaskCard
2. Delete confirmation dialog shown
3. User confirms → TaskViewModel.deleteTask() called
4. Repository → Data Source → API
5. State updated (task removed from list)
6. UI rebuilds
```

---

## State Management

### State Transitions

```
Initial State
    ↓
Loading (isLoading: true, tasks: [])
    ↓
    ├─→ Success (isLoading: false, tasks: [...])
    │       ↓
    │   Create/Update/Delete
    │       ↓
    │   Loading → Success (updated tasks)
    │
    └─→ Error (isLoading: false, errorMessage: "...")
            ↓
        Retry → Loading
```

### State Properties

| Property | Type | Description |
|----------|------|-------------|
| `tasks` | `List<TaskModel>` | List of all tasks |
| `isLoading` | `bool` | Loading indicator state |
| `errorMessage` | `String?` | Error message if any |

---

## UI Components

### TaskPage

- **AppBar**: Title "MVVM Architecture Example"
- **Body**: TaskList widget
- **FAB**: Opens TaskFormBottomSheet for creating tasks
- **Provider**: BlocProvider for TaskViewModel

### TaskList

- **Loading**: CircularProgressIndicator
- **Error**: ErrorWidget with retry button
- **Empty**: Empty state message with icon
- **Success**: ListView with RefreshIndicator

### TaskCard

- **Title**: Task title (strikethrough if completed)
- **Description**: Task description (truncated)
- **Category**: Category badge (if available)
- **Checkbox**: Toggle completion status
- **Date**: Creation date
- **Delete**: Delete button with confirmation

### TaskFormBottomSheet

- **Title Field**: Text input for task title
- **Description Field**: Multi-line text input
- **Category Field**: Optional category input
- **Validation**: Required field validation
- **Actions**: Cancel and Create/Update buttons

---

## Usage Examples

### 1. Navigate to Task Page

```dart
// From Examples page
context.push(AppRoutes.path(AppRoutes.exampleMvvm));
```

### 2. Access TaskViewModel

```dart
// Read state
final state = context.read<TaskViewModel>().state;

// Call methods
context.read<TaskViewModel>().loadTasks();
context.read<TaskViewModel>().createTask(
  title: 'Title',
  description: 'Description',
  category: 'Work',
);
```

### 3. Listen to State Changes

```dart
BlocBuilder<TaskViewModel, TaskState>(
  builder: (context, state) {
    if (state.isLoading) return LoadingWidget();
    if (state.errorMessage != null) return ErrorWidget();
    return TaskList(tasks: state.tasks);
  },
)
```

### 4. Handle Errors

```dart
BlocListener<TaskViewModel, TaskState>(
  listenWhen: (previous, current) => current.errorMessage != null,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.errorMessage!)),
    );
  },
  child: TaskList(),
)
```

---

## Adding New Features

### Example: Add Task Priority

#### 1. Update Model Layer

**Update `TaskModel`:**
```dart
class TaskModel extends Equatable {
  // ... existing fields
  final String? priority; // NEW (e.g., 'low', 'medium', 'high')
}
```

#### 2. Update Data Layer

**Update `TaskRemoteDataSource`:**
```dart
Future<TaskModel> createTask({
  required String title,
  required String description,
  String? category,
  String? priority, // NEW
});
```

**Update `TaskRemoteDataSourceImpl`:**
```dart
@override
Future<TaskModel> createTask({...}) async {
  // Include priority in API call
}
```

**Update `TaskRepositoryImpl`:**
```dart
Future<Either<ErrorMsg, TaskModel>> createTask({
  required String title,
  required String description,
  String? category,
  String? priority, // NEW
}) async {
  // Pass priority to data source
}
```

#### 3. Update ViewModel Layer

**Update `TaskViewModel`:**
```dart
Future<void> createTask({
  required String title,
  required String description,
  String? category,
  String? priority, // NEW
}) async {
  // Pass priority to repository
}
```

#### 4. Update View Layer

**Update `TaskFormBottomSheet`:**
```dart
// Add priority dropdown
DropdownButton<String>(
  items: ['Low', 'Medium', 'High'].map((p) {
    return DropdownMenuItem(value: p.toLowerCase(), child: Text(p));
  }).toList(),
  onChanged: (priority) {
    // Update priority
  },
)
```

---

## Best Practices

### 1. MVVM Principles

✅ **DO:**
- Keep ViewModel independent of View
- Use ViewModel for all business logic
- Keep View simple (only UI logic)
- Use data binding (BlocBuilder/BlocListener)
- Separate Model from ViewModel

❌ **DON'T:**
- Put business logic in View
- Access Model directly from View
- Create tight coupling between layers
- Mix UI logic with business logic
- Skip ViewModel layer

### 2. ViewModel Design

✅ **DO:**
- Use Cubit/Bloc for state management
- Emit loading state before async operations
- Handle errors gracefully
- Keep ViewModel testable
- Use repository pattern

❌ **DON'T:**
- Use setState in ViewModel
- Access UI components from ViewModel
- Forget to handle errors
- Create complex ViewModels
- Skip error handling

### 3. View Design

✅ **DO:**
- Keep View simple and focused
- Use BlocBuilder for reactive UI
- Handle loading/error/empty states
- Create reusable widgets
- Follow Material Design guidelines

❌ **DON'T:**
- Put business logic in View
- Access repository directly from View
- Forget to handle states
- Create complex widgets
- Skip user feedback

### 4. Model Design

✅ **DO:**
- Keep models simple and focused
- Use Equatable for comparison
- Implement JSON serialization
- Add copyWith methods
- Validate data in models

❌ **DON'T:**
- Add UI logic to models
- Create complex models
- Skip validation
- Forget immutability
- Mix concerns

---

## MVVM vs Clean Architecture

### MVVM Architecture

- **Layers**: Model, View, ViewModel
- **Focus**: UI separation, data binding
- **ViewModel**: Business logic + State management
- **Model**: Data structure
- **Use Cases**: Not required (optional)
- **Entities**: Not separate (Model serves as entity)

### Clean Architecture

- **Layers**: Domain, Data, Presentation
- **Focus**: Business logic separation, testability
- **Use Cases**: Required (business logic)
- **Entities**: Separate from Models
- **Repository**: Abstract interface + Implementation
- **Dependency Rule**: Inner layers don't depend on outer layers

### When to Use Which?

**Use MVVM when:**
- Building simple to medium complexity features
- Need quick development
- UI-focused applications
- Team familiar with MVVM pattern
- Less strict separation needed

**Use Clean Architecture when:**
- Building complex, enterprise applications
- Need high testability
- Multiple data sources
- Long-term maintenance important
- Strict separation required

### Comparison Table

| Aspect | MVVM | Clean Architecture |
|--------|------|-------------------|
| **Layers** | 3 (Model, View, ViewModel) | 3+ (Domain, Data, Presentation) |
| **Use Cases** | Optional | Required |
| **Entities** | Same as Model | Separate from Model |
| **Complexity** | Lower | Higher |
| **Testability** | Good | Excellent |
| **Learning Curve** | Easier | Steeper |
| **Best For** | Simple to medium apps | Complex, enterprise apps |

---

## Summary

The Example MVVM feature demonstrates:

1. **Complete MVVM**: Model, View, ViewModel layers
2. **State Management**: Reactive UI with Cubit
3. **Data Layer**: Repository pattern with data sources
4. **Error Handling**: Robust error management with Either
5. **CRUD Operations**: Full create, read, update, delete functionality
6. **Separation of Concerns**: Clear boundaries between layers

This implementation serves as a **template** for creating new features following MVVM principles. Use this as a reference when building MVVM-based features in your application.

---

## Key Takeaways

- **Model Layer**: Data structure and JSON serialization
- **ViewModel Layer**: Business logic and state management (Cubit)
- **View Layer**: UI components that observe ViewModel state
- **Data Layer**: Handles API calls and data operations
- **Dependency Injection**: All dependencies registered in injection file
- **Error Handling**: Either type for functional error handling
- **Testing**: ViewModel can be tested independently

Follow this structure for all MVVM features to maintain consistency and testability across your application.
