# Multi-Screen Cubit Sharing Guide

## Problem: AuthCubit Across Multiple Screens

### Scenario
You need `AuthCubit` in multiple screens:
- Login Screen
- Verify OTP Screen
- Password Recovery Screen
- Logout Screen
- Change Password Screen

### Current Issue (Route-Level + Factory)

```dart
// Current setup
sl.registerFactory<AuthCubit>(() => AuthCubit(...)); // New instance each time

// Login screen
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Instance 1
    child: const LoginScreen(),
  ),
)

// Verify OTP screen
GoRoute(
  path: '/verify-otp',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Instance 2 (NEW - loses login state!)
    child: const VerifyOtpScreen(),
  ),
)
```

**Problem:** ❌ Each screen gets a **fresh instance** - state is lost between screens!

---

## Solution: App-Level with Lazy Singleton ✅

For Cubits that need to be shared across multiple screens, use **app-level provider with lazy singleton**.

### Step 1: Change DI Registration to Lazy Singleton

```dart
// auth_injection.dart
void initAuthInjector() {
  // ... other registrations
  
  // ✅ Change from Factory to Lazy Singleton
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
  // Now same instance is reused across all screens
}
```

### Step 2: Provide at App Level

```dart
// flutter_sample_app.dart
BlocProvider(
  create: (context) => sl<AppCubit>(), // Global state
  child: BlocProvider.value(
    value: sl<AuthCubit>(), // ✅ Shared across all auth screens
    child: BlocBuilder<AppCubit, AppState>(...),
  ),
)
```

### Step 3: Access from Any Route

```dart
// login_screen.dart
context.read<AuthCubit>().loginUser(...); // ✅ Same instance

// verify_otp_screen.dart
context.read<AuthCubit>().verifyOtp(...); // ✅ Same instance (has login state)

// password_recovery_screen.dart
context.read<AuthCubit>().recoverPassword(...); // ✅ Same instance
```

---

## Complete Implementation

### 1. Update DI Registration

```dart
// lib/features/auth/auth_injection.dart
void initAuthInjector() {
  // ... existing registrations
  
  // ✅ Change to Lazy Singleton for multi-screen sharing
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
}
```

### 2. Update App-Level Provider

```dart
// lib/features/app/presentation/pages/flutter_sample_app.dart
BlocProvider(
  create: (context) => sl<AppCubit>(),
  child: BlocProvider.value(
    value: sl<AuthCubit>(), // ✅ Shared across all screens
    child: BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return MaterialApp.router(...);
      },
    ),
  ),
)
```

### 3. Remove Route-Level Providers

```dart
// lib/core/router/app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.login),
  name: AppRoutes.login,
  builder: (context, state) => const LoginScreen(), // ✅ No BlocProvider needed
),

GoRoute(
  path: AppRoutes.path(AppRoutes.verifyOtp),
  name: AppRoutes.verifyOtp,
  builder: (context, state) => const VerifyOtpScreen(), // ✅ Access shared instance
),
```

### 4. Add Reset State on Logout

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
class AuthCubit extends Cubit<AuthState> {
  // ... existing code
  
  Future<void> logout() async {
    // Clear authentication data
    await sl<AppPref>().logout();
    sl<ApiClient>().removeAuthToken();
    
    // ✅ Reset state to initial
    emit(const AuthState()); // Reset to initial state
  }
}
```

---

## When to Use Each Approach

### Use App-Level + Lazy Singleton ✅

**For:**
- `AuthCubit` - Used across login, OTP, password recovery, logout
- `ProfileCubit` - If accessed from multiple routes
- `NotificationCubit` - App-wide notifications
- Any Cubit shared across 3+ screens

**Benefits:**
- ✅ Same instance across all screens
- ✅ State persists between navigation
- ✅ Lazy loading (created on first access)

---

### Use Route-Level + Factory ✅

**For:**
- `DashboardCubit` - Only used in dashboard
- `ProductsCubit` - Only used in products list
- `SettingsCubit` - Only used in settings
- Any Cubit used in single screen

**Benefits:**
- ✅ Fresh state per route
- ✅ Memory efficient (disposed when route removed)
- ✅ No shared state issues

---

## Decision Matrix

| Cubit | Used In | Provider Level | Registration Type |
|-------|---------|---------------|-------------------|
| `AuthCubit` | Login, OTP, Password Recovery, Logout | ✅ App-Level | Lazy Singleton |
| `AppCubit` | Everywhere (theme, language) | ✅ App-Level | Lazy Singleton |
| `DashboardCubit` | Dashboard only | ✅ Route-Level | Factory |
| `ProductsCubit` | Products list only | ✅ Route-Level | Factory |
| `ProfileCubit` | Profile, Edit Profile, Settings | ✅ App-Level | Lazy Singleton |

---

## Complete Example: Auth Flow

### Auth Flow Screens
1. Login → Sets email/password
2. Verify OTP → Needs email from login
3. Password Recovery → Needs email
4. Logout → Resets all state

### Implementation

```dart
// 1. DI Registration (Lazy Singleton)
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...));

// 2. App-Level Provider
BlocProvider.value(
  value: sl<AuthCubit>(), // ✅ Shared instance
  child: MaterialApp.router(...),
)

// 3. Login Screen
class LoginScreen extends StatelessWidget {
  void _handleLogin(BuildContext context) {
    context.read<AuthCubit>().loginUser(
      email: email,
      password: password,
    );
    // State saved in AuthCubit
  }
}

// 4. Verify OTP Screen
class VerifyOtpScreen extends StatelessWidget {
  void _handleVerifyOtp(BuildContext context) {
    // ✅ Can access email from login (same instance)
    final email = context.read<AuthCubit>().state.email;
    context.read<AuthCubit>().verifyOtp(email: email, otp: otp);
  }
}

// 5. Logout
class LogoutButton extends StatelessWidget {
  void _handleLogout(BuildContext context) {
    context.read<AuthCubit>().logout(); // ✅ Resets state
  }
}
```

---

## Best Practices

### ✅ DO:

1. **Use App-Level for Multi-Screen Cubits**
   ```dart
   // AuthCubit used in 4+ screens
   BlocProvider.value(
     value: sl<AuthCubit>(), // ✅ App-level
     child: MaterialApp.router(...),
   )
   ```

2. **Use Lazy Singleton Registration**
   ```dart
   sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...)); // ✅
   ```

3. **Reset State on Logout**
   ```dart
   Future<void> logout() async {
     await clearData();
     emit(const AuthState()); // ✅ Reset state
   }
   ```

4. **Use Route-Level for Single-Screen Cubits**
   ```dart
   // DashboardCubit only in dashboard
   GoRoute(
     path: '/dashboard',
     builder: (context, state) => BlocProvider(
       create: (context) => sl<DashboardCubit>(), // ✅ Route-level
       child: const DashboardPage(),
     ),
   )
   ```

### ❌ DON'T:

1. **Don't Use Factory for Multi-Screen Cubits**
   ```dart
   // ❌ Bad - loses state between screens
   sl.registerFactory<AuthCubit>(() => AuthCubit(...));
   ```

2. **Don't Provide at Route-Level for Shared Cubits**
   ```dart
   // ❌ Bad - each route gets new instance
   GoRoute(
     path: '/login',
     builder: (context, state) => BlocProvider(
       create: (context) => sl<AuthCubit>(), // New instance
       child: const LoginScreen(),
     ),
   )
   ```

3. **Don't Forget to Reset State**
   ```dart
   // ❌ Bad - state persists after logout
   Future<void> logout() async {
     await clearData();
     // Missing: emit(const AuthState());
   }
   ```

---

## Migration Steps

### Step 1: Identify Multi-Screen Cubits

List all screens that need the same Cubit:
- `AuthCubit`: Login, OTP, Password Recovery, Logout ✅
- `ProfileCubit`: Profile, Edit Profile, Settings ✅
- `DashboardCubit`: Dashboard only ❌ (single screen)

### Step 2: Change DI Registration

```dart
// Before
sl.registerFactory<AuthCubit>(() => AuthCubit(...));

// After
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...)); // ✅
```

### Step 3: Move to App-Level

```dart
// flutter_sample_app.dart
BlocProvider.value(
  value: sl<AuthCubit>(), // ✅ App-level
  child: MaterialApp.router(...),
)
```

### Step 4: Remove Route-Level Providers

```dart
// app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => const LoginScreen(), // ✅ No BlocProvider
),
```

### Step 5: Add Reset Logic

```dart
// auth_cubit.dart
Future<void> logout() async {
  await clearData();
  emit(const AuthState()); // ✅ Reset state
}
```

---

## Performance Impact

### Memory Usage

| Approach | Memory at Startup | Memory After Login | Memory After Logout |
|----------|------------------|-------------------|---------------------|
| **Route-Level + Factory** | ✅ 0 KB | ✅ ~5 KB (per route) | ✅ 0 KB (disposed) |
| **App-Level + Lazy Singleton** | ✅ 0 KB | ✅ ~5 KB (shared) | ⚠️ ~5 KB (persists) |

**Note:** App-level persists until logout, but this is acceptable for auth state.

---

## Conclusion

### For Multi-Screen Cubits (AuthCubit):

✅ **Use App-Level + Lazy Singleton**
- Same instance across all screens
- State persists between navigation
- Lazy loading (created on first access)
- Reset state on logout

### For Single-Screen Cubits (DashboardCubit):

✅ **Use Route-Level + Factory**
- Fresh state per route
- Memory efficient
- No shared state issues

**Your AuthCubit scenario:** ✅ Use app-level + lazy singleton!
