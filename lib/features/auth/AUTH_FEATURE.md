# Authentication Feature - Complete Guide

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [File Structure](#file-structure)
4. [Component Details](#component-details)
5. [Data Flow](#data-flow)
6. [State Management](#state-management)
7. [UI Components](#ui-components)
8. [Usage Examples](#usage-examples)
9. [Adding New Features](#adding-new-features)
10. [Recent Updates & Best Practices](#recent-updates--best-practices)

---

## Overview

The Authentication feature implements a complete login/logout system following **Clean Architecture** principles. It demonstrates:

- ✅ **Clean Architecture** (Domain, Data, Presentation layers)
- ✅ **Repository Pattern** (Abstract interface + Implementation)
- ✅ **Use Case Pattern** (Business logic encapsulation)
- ✅ **State Management** (Cubit/Bloc pattern)
- ✅ **Dependency Injection** (GetIt service locator)
- ✅ **Error Handling** (Either/Left/Right pattern)
- ✅ **Multi-Screen State Sharing** (App-level Cubit provider)

### Features Implemented

- ✅ User login with email/password
- ✅ Remember me functionality
- ✅ Token management (access + refresh tokens)
- ✅ Automatic navigation after login
- ✅ Logout functionality
- ✅ Authentication state persistence
- ✅ Mock API support for development
- ✅ Error handling and user feedback

---

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│  (UI, Widgets, State Management)        │
│  - LoginScreen                          │
│  - AuthCubit (State Management)        │
│  - AuthState (Freezed)                  │
│  - Reusable Widgets                    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│           DOMAIN LAYER                   │
│  (Business Logic, Entities)             │
│  - LoginEntity                          │
│  - AuthRepository (Interface)           │
│  - LoginUseCase                         │
│  - LoginParams                          │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│            DATA LAYER                    │
│  (API, Storage, Models)                 │
│  - AuthRepositoryImpl                   │
│  - AuthRemoteDataSource (Interface)     │
│  - AuthRemoteDataSourceImpl            │
│  - LoginResponse (Model)                │
│  - LoginMapper                          │
└─────────────────────────────────────────┘
```

### Dependency Flow

```
UI (LoginScreen)
    ↓
AuthCubit (State Management)
    ↓
LoginUseCase (Business Logic)
    ↓
AuthRepository (Interface)
    ↓
AuthRepositoryImpl (Implementation)
    ↓
AuthRemoteDataSource (Interface)
    ↓
AuthRemoteDataSourceImpl (API Calls)
    ↓
ApiClient (HTTP Client)
```

---

## File Structure

```
lib/features/auth/
├── auth_injection.dart                    # Dependency Injection setup
│
├── domain/                                # Business Logic Layer
│   ├── entities/
│   │   └── login_entity.dart             # Domain entity (pure Dart)
│   ├── repositories/
│   │   └── auth_repository.dart          # Repository interface
│   └── use_cases/
│       └── login_use_case.dart           # Login business logic
│
├── data/                                  # Data Layer
│   ├── data_sources/
│   │   ├── auth_remote_data_source.dart  # Data source interface
│   │   └── auth_remote_data_source_impl.dart  # API implementation
│   ├── models/
│   │   └── login_response.dart           # API response model
│   ├── mappers/
│   │   └── login_mapper.dart             # Model → Entity mapper
│   └── repositories/
│       └── auth_repository_impl.dart     # Repository implementation
│
└── presentation/                          # UI Layer
    ├── cubit/
    │   ├── auth_cubit.dart               # State management
    │   ├── auth_state.dart                # State definition (Freezed)
    │   └── auth_state.freezed.dart       # Generated code
    ├── pages/
    │   └── login_screen.dart             # Login UI screen
    └── widgets/
        ├── remember_me_forgot_password_row_widget.dart
        ├── sign_up_row_widget.dart
        └── welcome_back_widget.dart
```

---

## Component Details

### 1. Domain Layer

#### LoginEntity (`domain/entities/login_entity.dart`)

Pure Dart class representing the business entity (no framework dependencies).

```dart
class LoginEntity extends Equatable {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final DateTime? expiresAt;
}
```

**Purpose:**
- Represents authentication data in the domain layer
- Framework-independent (can be used in any layer)
- Immutable (using Equatable for value comparison)

---

#### AuthRepository (`domain/repositories/auth_repository.dart`)

Abstract interface defining authentication operations.

```dart
abstract class AuthRepository {
  Future<Either<ErrorMsg, LoginEntity>> loginUser({
    required LoginParams params,
  });
  
  Future<Either<ErrorMsg, void>> logout();
  
  Future<Either<ErrorMsg, bool>> isAuthenticated();
}
```

**Purpose:**
- Defines contract for authentication operations
- Allows different implementations (API, local storage, etc.)
- Returns `Either<ErrorMsg, T>` for error handling

---

#### LoginUseCase (`domain/use_cases/login_use_case.dart`)

Encapsulates login business logic.

```dart
class LoginUseCase extends UseCase<LoginEntity, LoginParams> {
  final AuthRepository authRepository;

  @override
  Future<Either<ErrorMsg, LoginEntity>> call(LoginParams params) async {
    return await authRepository.loginUser(params: params);
  }
}
```

**Purpose:**
- Single responsibility: login business logic
- Reusable across different UI implementations
- Testable in isolation

**LoginParams:**
```dart
class LoginParams extends Equatable {
  final String email;
  final String password;
}
```

---

### 2. Data Layer

#### LoginResponse (`data/models/login_response.dart`)

API response model with JSON serialization.

```dart
class LoginResponse {
  final String token;
  final String userId;
  final String email;
  final String? refreshToken;
  final int? expiresIn;

  factory LoginResponse.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**Purpose:**
- Represents API response structure
- Handles JSON parsing
- Supports alternative key names (e.g., `userId` vs `user_id`)

---

#### LoginMapper (`data/mappers/login_mapper.dart`)

Converts API model to domain entity.

```dart
class LoginMapper {
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

**Purpose:**
- Separates data layer from domain layer
- Transforms API-specific data to business entities
- Handles data conversion (e.g., `expiresIn` → `expiresAt`)

---

#### AuthRemoteDataSource (`data/data_sources/auth_remote_data_source.dart`)

Interface for remote data operations.

```dart
abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
}
```

**Purpose:**
- Defines contract for API operations
- Allows mocking for testing
- Can be swapped with different implementations

---

#### AuthRemoteDataSourceImpl (`data/data_sources/auth_remote_data_source_impl.dart`)

Implementation of remote data source using `ApiClient`.

**Key Features:**
- ✅ Mock API support (debug mode)
- ✅ Error handling
- ✅ Response validation
- ✅ Network delay simulation (mock mode)

```dart
@override
Future<LoginResponse> login(String email, String password) async {
  // Check if mock mode is enabled
  if (MockApiResponses.useMockData) {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockResponse = MockApiResponses.mockLoginResponse;
    mockResponse['email'] = email; // Update with actual email
    return LoginResponse.fromJson(mockResponse);
  }

  // Real API call
  final response = await apiClient.post(
    AppUrls.login,
    body: {'email': email, 'password': password},
  );

  return LoginResponse.fromJson(response);
}
```

---

#### AuthRepositoryImpl (`data/repositories/auth_repository_impl.dart`)

Implements `AuthRepository` interface.

**Key Features:**
- ✅ Error handling with `Either` pattern
- ✅ Model to Entity mapping
- ✅ Local storage integration (`AppPref`)
- ✅ Graceful error handling (clears data even on API failure)

```dart
@override
Future<Either<ErrorMsg, LoginEntity>> loginUser({
  required LoginParams params,
}) async {
  try {
    final response = await remoteDataSource.login(
      params.email,
      params.password,
    );
    final entity = LoginMapper.toEntity(response);
    return Right(entity);
  } on ApiException catch (e) {
    return Left(e.message);
  } catch (e) {
    return Left(e.toString());
  }
}
```

---

### 3. Presentation Layer

#### AuthState (`presentation/cubit/auth_state.dart`)

Immutable state class using Freezed.

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(StateStatus.idle) StateStatus loginStatus,
    @Default(StateStatus.idle) StateStatus verifyOtpState,
    LoginEntity? loginEntity,
    @Default(false) bool rememberMe,
  }) = _AuthState;
}
```

**State Properties:**
- `loginStatus`: Loading, success, error states
- `verifyOtpState`: OTP verification status (for future use)
- `loginEntity`: User authentication data
- `rememberMe`: Remember me checkbox state

**StateStatus Enum:**
```dart
enum StateStatus {
  idle,      // Initial state
  loading,   // Operation in progress
  success,   // Operation successful
  error,     // Operation failed
}
```

---

#### AuthCubit (`presentation/cubit/auth_cubit.dart`)

State management for authentication.

**Key Methods:**

1. **`toggleRememberMe(bool value)`**
   - Updates remember me checkbox state
   - Uses Cubit state management (no setState)

2. **`loginUser({required BuildContext context, required String email, required String password})`**
   - Initiates login process
   - Updates state: loading → success/error
   - Saves token to `AppPref`
   - Updates `ApiClient` with auth token
   - Navigates to dashboard on success

3. **`logout()`**
   - Clears authentication data
   - Removes token from `ApiClient`
   - Resets state to initial

```dart
Future<void> loginUser({
  required BuildContext context,
  required String email,
  required String password,
}) async {
  emit(state.copyWith(loginStatus: StateStatus.loading));

  final params = LoginParams(email: email, password: password);
  final result = await loginUseCase.call(params);

  result.fold(
    // Error
    (error) {
      emit(state.copyWith(loginStatus: StateStatus.error));
      ErrorSnackBar.show(context, error);
    },
    // Success
    (response) async {
      // Save authentication data
      final appPref = sl<AppPref>();
      await appPref.setToken(response.token);
      await appPref.setUserId(response.userId);
      if (response.refreshToken != null) {
        await appPref.setRefreshToken(response.refreshToken!);
      }

      // Update API client
      sl<ApiClient>().setAuthToken(response.token);

      emit(state.copyWith(
        loginStatus: StateStatus.success,
        loginEntity: response,
      ));

      // Navigate to dashboard
      if (context.mounted) {
        context.pushReplacementNamed(AppRoutes.dashboard);
      }
    },
  );
}
```

---

#### LoginScreen (`presentation/pages/login_screen.dart`)

Main login UI screen.

**Features:**
- ✅ Modern gradient design
- ✅ Form validation
- ✅ Focus management
- ✅ Loading state handling
- ✅ Reusable widgets

**Structure:**
```dart
class LoginScreen extends StatefulWidget {
  // Form controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Login handler
  void _handleLogin(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().loginUser(
        context: context,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
```

**UI Components:**
- `AppLogoWidget()` - App logo/icon
- `WelcomeBackWidget()` - Welcome text
- `AppEmailField()` - Email input field
- `AppPasswordField()` - Password input with visibility toggle
- `RememberMeForgotPasswordRowWidget()` - Remember me + forgot password
- `AppButton()` - Login button with loading state
- `SignUpRowWidget()` - Sign up link

---

#### Reusable Widgets

##### RememberMeForgotPasswordRowWidget

Manages remember me checkbox using Cubit state.

```dart
BlocSelector<AuthCubit, AuthState, bool>(
  selector: (state) => state.rememberMe,
  builder: (context, rememberMe) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) {
            context.read<AuthCubit>().toggleRememberMe(value ?? false);
          },
        ),
        Text(AppStrings.rememberMe),
        TextButton(
          onPressed: () => showForgotPasswordSnackBar(context),
          child: Text(AppStrings.forgotPassword),
        ),
      ],
    );
  },
)
```

**Key Points:**
- ✅ Uses `BlocSelector` for efficient rebuilds
- ✅ State managed by Cubit (no setState)
- ✅ Reusable across auth screens

##### WelcomeBackWidget

Displays welcome message and sign-in text.

##### SignUpRowWidget

Shows "Don't have an account? Sign up" link.

---

## Data Flow

### Login Flow

```
1. User enters email/password
   ↓
2. LoginScreen calls AuthCubit.loginUser()
   ↓
3. AuthCubit emits loading state
   ↓
4. AuthCubit calls LoginUseCase.call()
   ↓
5. LoginUseCase calls AuthRepository.loginUser()
   ↓
6. AuthRepositoryImpl calls AuthRemoteDataSource.login()
   ↓
7. AuthRemoteDataSourceImpl makes API call (or returns mock)
   ↓
8. LoginResponse model created from JSON
   ↓
9. LoginMapper converts LoginResponse → LoginEntity
   ↓
10. Either<ErrorMsg, LoginEntity> returned up the chain
   ↓
11. AuthCubit handles result:
    - Success: Save token, update ApiClient, emit success, navigate
    - Error: Emit error, show error message
```

### Logout Flow

```
1. User clicks logout
   ↓
2. AuthCubit.logout() called
   ↓
3. Clear AppPref (tokens, user data)
   ↓
4. Remove token from ApiClient
   ↓
5. Reset AuthState to initial
   ↓
6. Navigate to login (if needed)
```

---

## State Management

### Provider Strategy

**AuthCubit is provided at App-Level** using `MultiBlocProvider`:

```dart
// flutter_sample_app.dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => sl<AppCubit>()),
    BlocProvider.value(value: sl<AuthCubit>()), // ✅ Shared instance
  ],
  child: MaterialApp.router(...),
)
```

**Why App-Level?**
- ✅ Shared across multiple auth screens (login, OTP, password recovery, logout)
- ✅ State persists between navigation
- ✅ Same instance reused (lazy singleton)

**Registration:**
```dart
// auth_injection.dart
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
```

### State Access

```dart
// In any widget
final authCubit = context.read<AuthCubit>();
final authState = context.watch<AuthCubit>().state;

// Select specific state property
BlocSelector<AuthCubit, AuthState, StateStatus>(
  selector: (state) => state.loginStatus,
  builder: (context, loginStatus) {
    return loginStatus == StateStatus.loading
        ? CircularProgressIndicator()
        : LoginButton();
  },
)
```

---

## UI Components

### Login Screen Layout

```
┌─────────────────────────────────┐
│         App Logo                │
│                                 │
│      Welcome Back!              │
│      Sign in to continue        │
│                                 │
│  ┌─────────────────────────┐   │
│  │  Email Field             │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  Password Field          │   │
│  └─────────────────────────┘   │
│                                 │
│  ☑ Remember Me    Forgot?      │
│                                 │
│  ┌─────────────────────────┐   │
│  │    Sign In Button       │   │
│  └─────────────────────────┘   │
│                                 │
│  Don't have account? Sign up    │
└─────────────────────────────────┘
```

### Widget Hierarchy

```
LoginScreen
└── Scaffold
    └── Container (Gradient Background)
        └── SafeArea
            └── Center
                └── SingleChildScrollView
                    └── Form
                        └── Column
                            ├── AppLogoWidget
                            ├── WelcomeBackWidget
                            ├── AppEmailField
                            ├── AppPasswordField
                            ├── RememberMeForgotPasswordRowWidget
                            ├── BlocSelector + AppButton
                            └── SignUpRowWidget
```

---

## Usage Examples

### 1. Basic Login

```dart
// In LoginScreen
void _handleLogin(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    context.read<AuthCubit>().loginUser(
      context: context,
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }
}
```

### 2. Access Auth State

```dart
// Get current login status
final loginStatus = context.watch<AuthCubit>().state.loginStatus;

// Get user data
final loginEntity = context.watch<AuthCubit>().state.loginEntity;
final email = loginEntity?.email;
```

### 3. Toggle Remember Me

```dart
// In widget
Checkbox(
  value: context.watch<AuthCubit>().state.rememberMe,
  onChanged: (value) {
    context.read<AuthCubit>().toggleRememberMe(value ?? false);
  },
)
```

### 4. Logout

```dart
// In any screen
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().logout();
    // Navigate to login if needed
  },
  child: Text('Logout'),
)
```

### 5. Check Authentication Status

```dart
// Using repository
final result = await sl<AuthRepository>().isAuthenticated();
result.fold(
  (error) => print('Error: $error'),
  (isAuthenticated) => print('Authenticated: $isAuthenticated'),
);
```

---

## Adding New Features

### Guide: Adding Verify OTP Feature

#### Step 1: Create Entity (Domain)

```dart
// domain/entities/verify_otp_entity.dart
class VerifyOtpEntity extends Equatable {
  final bool verified;
  final String? token;

  const VerifyOtpEntity({
    required this.verified,
    this.token,
  });

  @override
  List<Object?> get props => [verified, token];
}
```

#### Step 2: Create Use Case (Domain)

```dart
// domain/use_cases/verify_otp_use_case.dart
class VerifyOtpUseCase extends UseCase<VerifyOtpEntity, VerifyOtpParams> {
  final AuthRepository authRepository;

  VerifyOtpUseCase({required this.authRepository});

  @override
  Future<Either<ErrorMsg, VerifyOtpEntity>> call(VerifyOtpParams params) async {
    return await authRepository.verifyOtp(params: params);
  }
}

class VerifyOtpParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}
```

#### Step 3: Update Repository Interface (Domain)

```dart
// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  // ... existing methods
  
  Future<Either<ErrorMsg, VerifyOtpEntity>> verifyOtp({
    required VerifyOtpParams params,
  });
}
```

#### Step 4: Create Model (Data)

```dart
// data/models/verify_otp_response.dart
class VerifyOtpResponse {
  final bool verified;
  final String? token;

  VerifyOtpResponse({
    required this.verified,
    this.token,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      verified: json['verified'] as bool,
      token: json['token'] as String?,
    );
  }
}
```

#### Step 5: Create Mapper (Data)

```dart
// data/mappers/verify_otp_mapper.dart
class VerifyOtpMapper {
  static VerifyOtpEntity toEntity(VerifyOtpResponse response) {
    return VerifyOtpEntity(
      verified: response.verified,
      token: response.token,
    );
  }
}
```

#### Step 6: Update Data Source (Data)

```dart
// data/data_sources/auth_remote_data_source.dart
abstract class AuthRemoteDataSource {
  // ... existing methods
  
  Future<VerifyOtpResponse> verifyOtp(String email, String otp);
}

// data/data_sources/auth_remote_data_source_impl.dart
@override
Future<VerifyOtpResponse> verifyOtp(String email, String otp) async {
  if (MockApiResponses.useMockData) {
    await Future.delayed(const Duration(milliseconds: 500));
    return VerifyOtpResponse.fromJson({
      'verified': true,
      'token': 'mock_token',
    });
  }

  final response = await apiClient.post(
    AppUrls.verifyOtp,
    body: {'email': email, 'otp': otp},
  );

  return VerifyOtpResponse.fromJson(response);
}
```

#### Step 7: Update Repository Implementation (Data)

```dart
// data/repositories/auth_repository_impl.dart
@override
Future<Either<ErrorMsg, VerifyOtpEntity>> verifyOtp({
  required VerifyOtpParams params,
}) async {
  try {
    final response = await remoteDataSource.verifyOtp(
      params.email,
      params.otp,
    );
    final entity = VerifyOtpMapper.toEntity(response);
    return Right(entity);
  } on ApiException catch (e) {
    return Left(e.message);
  } catch (e) {
    return Left(e.toString());
  }
}
```

#### Step 8: Update State (Presentation)

```dart
// presentation/cubit/auth_state.dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    // ... existing fields
    @Default(StateStatus.idle) StateStatus verifyOtpStatus,
    VerifyOtpEntity? verifyOtpEntity,
  }) = _AuthState;
}
```

#### Step 9: Add Method to Cubit (Presentation)

```dart
// presentation/cubit/auth_cubit.dart
Future<void> verifyOtp({
  required BuildContext context,
  required String email,
  required String otp,
}) async {
  emit(state.copyWith(verifyOtpStatus: StateStatus.loading));

  final params = VerifyOtpParams(email: email, otp: otp);
  final result = await verifyOtpUseCase.call(params);

  result.fold(
    (error) {
      emit(state.copyWith(verifyOtpStatus: StateStatus.error));
      ErrorSnackBar.show(context, error);
    },
    (response) {
      emit(state.copyWith(
        verifyOtpStatus: StateStatus.success,
        verifyOtpEntity: response,
      ));
      // Navigate or handle success
    },
  );
}
```

#### Step 10: Update Dependency Injection

```dart
// auth_injection.dart
void initAuthInjector() {
  // ... existing registrations

  // Register new use case
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(authRepository: sl<AuthRepository>()),
  );
}
```

#### Step 11: Create UI Screen

```dart
// presentation/pages/verify_otp_screen.dart
class VerifyOtpScreen extends StatelessWidget {
  final String email; // From login screen

  void _handleVerifyOtp(BuildContext context, String otp) {
    context.read<AuthCubit>().verifyOtp(
      context: context,
      email: email,
      otp: otp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.verifyOtpStatus == StateStatus.success) {
          // Navigate to dashboard
        }
      },
      child: Scaffold(
        // OTP input UI
      ),
    );
  }
}
```

#### Step 12: Add Route

```dart
// app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.verifyOtp),
  name: AppRoutes.verifyOtp,
  builder: (context, state) => const VerifyOtpScreen(),
),
```

---

## Recent Updates & Best Practices

### 1. Multi-Screen Cubit Sharing ✅

**What Changed:**
- `AuthCubit` moved from route-level to app-level provider
- Changed from `registerFactory` to `registerLazySingleton`

**Why:**
- Auth flow spans multiple screens (login → OTP → password recovery)
- State needs to persist between navigation
- Same instance shared across all auth screens

**Implementation:**
```dart
// auth_injection.dart
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));

// flutter_sample_app.dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => sl<AppCubit>()),
    BlocProvider.value(value: sl<AuthCubit>()), // ✅ Shared
  ],
  child: MaterialApp.router(...),
)
```

**Benefits:**
- ✅ State persists between screens
- ✅ Email from login available in OTP screen
- ✅ Lazy loading (created on first access)

---

### 2. Remember Me with Cubit State ✅

**What Changed:**
- Remember me checkbox state moved from local `setState` to Cubit

**Implementation:**
```dart
// AuthState
@Default(false) bool rememberMe,

// AuthCubit
void toggleRememberMe(bool value) {
  emit(state.copyWith(rememberMe: value));
}

// Widget
BlocSelector<AuthCubit, AuthState, bool>(
  selector: (state) => state.rememberMe,
  builder: (context, rememberMe) {
    return Checkbox(
      value: rememberMe,
      onChanged: (value) {
        context.read<AuthCubit>().toggleRememberMe(value ?? false);
      },
    );
  },
)
```

**Benefits:**
- ✅ No setState needed
- ✅ State managed centrally
- ✅ Can be accessed from any screen

---

### 3. Automatic Navigation After Login ✅

**What Changed:**
- Navigation moved from `BlocListener` in UI to `AuthCubit`

**Implementation:**
```dart
// auth_cubit.dart
Future<void> loginUser(...) async {
  // ... login logic
  result.fold(
    (error) => { /* error handling */ },
    (response) async {
      // ... save data
      emit(state.copyWith(loginStatus: StateStatus.success));
      
      // Navigate
      if (context.mounted) {
        context.pushReplacementNamed(AppRoutes.dashboard);
      }
    },
  );
}
```

**Benefits:**
- ✅ Navigation logic in business layer
- ✅ Consistent navigation behavior
- ✅ No need for BlocListener in UI

---

### 4. Logout with State Reset ✅

**What Changed:**
- Added `logout()` method that resets state

**Implementation:**
```dart
Future<void> logout() async {
  try {
    await appPref.logout();
    sl<ApiClient>().removeAuthToken();
    emit(const AuthState()); // ✅ Reset to initial state
  } catch (e) {
    emit(const AuthState()); // Reset even on error
  }
}
```

**Benefits:**
- ✅ Clean state after logout
- ✅ No stale data
- ✅ Ready for next login

---

### 5. Mock API Support ✅

**What Changed:**
- Added mock API responses for development

**Implementation:**
```dart
// mockapi_responses.dart
static const bool useMockData = kDebugMode;

static Map<String, dynamic> get mockLoginResponse => {
  'token': 'mock_jwt_token_12345',
  'userId': 'mock_user_123',
  'email': 'test@example.com',
  // ...
};

// auth_remote_data_source_impl.dart
if (MockApiResponses.useMockData) {
  await Future.delayed(const Duration(milliseconds: 500));
  return LoginResponse.fromJson(MockApiResponses.mockLoginResponse);
}
```

**Benefits:**
- ✅ Development without backend
- ✅ Consistent test data
- ✅ Faster development cycle

---

## Best Practices Summary

### ✅ DO:

1. **Use Clean Architecture**
   - Separate Domain, Data, Presentation layers
   - Use interfaces for repositories and data sources

2. **Use Either Pattern for Error Handling**
   - `Either<ErrorMsg, T>` for all repository methods
   - Clear error propagation

3. **Use Use Cases for Business Logic**
   - Single responsibility
   - Testable in isolation

4. **Use Mappers for Data Transformation**
   - Model → Entity conversion
   - Keep layers independent

5. **Provide Multi-Screen Cubits at App-Level**
   - Use lazy singleton for shared state
   - State persists between navigation

6. **Use BlocSelector for Efficient Rebuilds**
   - Only rebuild when specific state changes
   - Better performance

7. **Save Tokens Immediately After Login**
   - Update `AppPref` and `ApiClient`
   - Ensure subsequent API calls have token

8. **Reset State on Logout**
   - Clear all auth data
   - Reset to initial state

### ❌ DON'T:

1. **Don't Mix Layers**
   - Don't use UI widgets in domain layer
   - Don't use domain entities in data models

2. **Don't Use setState for Cubit State**
   - Use Cubit methods to update state
   - Access state via `context.read` or `context.watch`

3. **Don't Create New Instances for Shared Cubits**
   - Use lazy singleton for multi-screen Cubits
   - Use factory only for single-screen Cubits

4. **Don't Forget Error Handling**
   - Always handle `Either.left` (errors)
   - Show user-friendly error messages

5. **Don't Hardcode API URLs**
   - Use `AppUrls` constants
   - Centralized URL management

---

## Testing

### Unit Testing Example

```dart
// test/features/auth/domain/use_cases/login_use_case_test.dart
void main() {
  group('LoginUseCase', () {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(authRepository: mockRepository);
    });

    test('should return LoginEntity when login is successful', () async {
      // Arrange
      final params = LoginParams(email: 'test@test.com', password: 'password');
      final entity = LoginEntity(...);
      when(mockRepository.loginUser(params: params))
          .thenAnswer((_) async => Right(entity));

      // Act
      final result = await loginUseCase.call(params);

      // Assert
      expect(result, Right(entity));
      verify(mockRepository.loginUser(params: params)).called(1);
    });
  });
}
```

---

## Troubleshooting

### Issue: State Not Updating

**Solution:**
- Ensure `BlocProvider` is in widget tree
- Use `context.watch<AuthCubit>()` for reactive updates
- Use `BlocSelector` for specific state properties

### Issue: Navigation Not Working

**Solution:**
- Check `context.mounted` before navigation
- Ensure route is registered in `app_router.dart`
- Use `pushReplacementNamed` for login → dashboard

### Issue: Token Not Persisting

**Solution:**
- Check `AppPref` implementation
- Verify `setToken()` is called after login
- Check `ApiClient.setAuthToken()` is called

---

## Summary

The Authentication feature demonstrates:

- ✅ **Clean Architecture** with clear layer separation
- ✅ **Repository Pattern** for data abstraction
- ✅ **Use Case Pattern** for business logic
- ✅ **State Management** with Cubit/Bloc
- ✅ **Multi-Screen State Sharing** with app-level providers
- ✅ **Error Handling** with Either pattern
- ✅ **Mock API Support** for development
- ✅ **Reusable UI Components**

This architecture is scalable, testable, and maintainable. Use it as a template for other features in your application.

---

**Last Updated:** 2024
**Version:** 1.0.0
