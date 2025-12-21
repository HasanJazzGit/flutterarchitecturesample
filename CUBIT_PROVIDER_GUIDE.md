# Cubit Provider Strategy Guide

## Overview

This guide explains the best practices for providing Cubits in Flutter applications, comparing different approaches and recommending the optimal strategy.

## Three Approaches Compared

### 1. **App-Level (All Cubits at Root)** ❌ Not Recommended
```dart
// Example from womenworld project
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => sl<AuthCubit>()),
    BlocProvider(create: (context) => sl<ProfileCubit>()),
    BlocProvider(create: (context) => sl<HomeCubit>()),
    // ... 20+ more Cubits
  ],
  child: MaterialApp.router(...),
)
```

**Problems:**
- ❌ Creates ALL Cubit instances at app startup (even if never used)
- ❌ Wastes memory and resources
- ❌ Slower app initialization
- ❌ Shared state across routes (can cause bugs)
- ❌ Hard to test (all Cubits initialized)
- ❌ No fresh state per route (e.g., login form keeps old data)

**When to use:** Only for truly global state (theme, language, app settings)

---

### 2. **Route-Level (Current Approach)** ✅ Recommended
```dart
// In app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Fresh instance per route
    child: const LoginScreen(),
  ),
),
```

**Benefits:**
- ✅ Creates Cubit only when route is accessed
- ✅ Fresh state per route (no stale data)
- ✅ Better memory management
- ✅ Easier to test (only needed Cubits)
- ✅ Clear lifecycle (disposed when route is removed)

**When to use:** Feature-specific Cubits (Auth, Dashboard, Products, etc.)

---

### 3. **Screen-Level** ⚠️ Rarely Needed
```dart
// Inside a widget
BlocProvider(
  create: (context) => SomeLocalCubit(),
  child: SomeWidget(),
)
```

**When to use:** Temporary/local state that doesn't need to persist across navigation

---

## Recommended Hybrid Approach ✅

### App-Level (Global State)
Provide only Cubits that need to persist across the entire app:

```dart
// flutter_sample_app.dart
BlocProvider(
  create: (context) => sl<AppCubit>(), // Theme, language, app settings
  child: MaterialApp.router(...),
)
```

**Candidates:**
- `AppCubit` - Theme, language, app-wide settings
- `WorkoutTimerCubit` - If timer needs to persist across routes
- `NotificationCubit` - If notifications are app-wide

### Route-Level (Feature State)
Provide feature-specific Cubits at route level:

```dart
// app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Fresh instance
    child: const LoginScreen(),
  ),
),

GoRoute(
  path: '/dashboard',
  builder: (context, state) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: sl<DashboardCubit>()),
      BlocProvider.value(value: sl<AppCubit>()), // Access app-level Cubit
    ],
    child: const DashboardPage(),
  ),
),
```

**Candidates:**
- `AuthCubit` - Login/logout state (fresh per login)
- `DashboardCubit` - Dashboard-specific data
- `ProductsCubit` - Product listing state
- `ProfileCubit` - User profile (if not global)
- All feature-specific Cubits

---

## Current Project Implementation ✅

### App-Level Provider
```dart
// lib/features/app/presentation/pages/flutter_sample_app.dart
BlocProvider(
  create: (context) => sl<AppCubit>(), // ✅ Only global state
  child: BlocBuilder<AppCubit, AppState>(...),
)
```

### Route-Level Providers
```dart
// lib/core/router/app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.login),
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // ✅ Fresh instance
    child: const LoginScreen(),
  ),
),

GoRoute(
  path: AppRoutes.path(AppRoutes.dashboard),
  builder: (context, state) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: sl<DashboardCubit>()),
      BlocProvider.value(value: sl<AppCubit>()), // ✅ Access app-level
    ],
    child: const DashboardPage(),
  ),
),
```

---

## Decision Matrix

| Cubit Type | Provider Level | Reason |
|------------|---------------|--------|
| `AppCubit` | App-Level | Theme, language - needed everywhere |
| `AuthCubit` | Route-Level | Fresh state per login, disposed after logout |
| `DashboardCubit` | Route-Level | Feature-specific, fresh data per visit |
| `ProductsCubit` | Route-Level | Feature-specific, fresh listing |
| `ProfileCubit` | Route-Level or App-Level | Depends: if accessed from multiple routes → App-Level, if single route → Route-Level |
| `WorkoutTimerCubit` | App-Level | If timer must persist across routes |
| `NotificationCubit` | App-Level | If notifications are app-wide |

---

## Issues with the Example (womenworld)

### Problems Identified:

1. **All Cubits at App Level**
   ```dart
   // ❌ Creates 20+ Cubits even if user never visits those features
   MultiBlocProvider(
     providers: [
       BlocProvider(create: (context) => sl<AuthCubit>()),
       BlocProvider(create: (context) => sl<ProfileCubit>()),
       // ... 18 more
     ],
   )
   ```

2. **Shared State Issues**
   - `AuthCubit` at app level means login form keeps old data
   - User logs out, but `AuthCubit` state persists
   - Multiple routes accessing same Cubit instance can cause conflicts

3. **Memory Waste**
   - Creates instances for features user may never use
   - All Cubits initialized at app startup

4. **Inconsistent Pattern**
   - `AppCubit()` created directly (not from DI)
   - `WorkoutTimerCubit()` created directly
   - Others use `sl<Cubit>()` from DI

---

## Best Practices

### ✅ DO:

1. **Use App-Level for Global State Only**
   ```dart
   // Only truly global Cubits
   BlocProvider(
     create: (context) => sl<AppCubit>(),
     child: MaterialApp.router(...),
   )
   ```

2. **Use Route-Level for Feature Cubits**
   ```dart
   GoRoute(
     path: '/feature',
     builder: (context, state) => BlocProvider(
       create: (context) => sl<FeatureCubit>(), // Fresh instance
       child: FeatureScreen(),
     ),
   )
   ```

3. **Use Factory Registration in DI**
   ```dart
   // auth_injection.dart
   sl.registerFactory<AuthCubit>(() => AuthCubit(sl<LoginUseCase>()));
   ```
   - Ensures fresh instance per route
   - Better memory management

4. **Access App-Level Cubit from Routes**
   ```dart
   // In route-level widget
   BlocProvider.value(
     value: context.read<AppCubit>(), // Access app-level Cubit
     child: SomeWidget(),
   )
   ```

### ❌ DON'T:

1. **Don't Put All Cubits at App Level**
   ```dart
   // ❌ Bad
   MultiBlocProvider(
     providers: [/* 20+ Cubits */],
   )
   ```

2. **Don't Mix Direct Creation with DI**
   ```dart
   // ❌ Inconsistent
   BlocProvider(create: (context) => AppCubit()), // Direct
   BlocProvider(create: (context) => sl<AuthCubit>()), // DI
   ```

3. **Don't Use Singleton for Cubits**
   ```dart
   // ❌ Bad - shared state across routes
   sl.registerLazySingleton<AuthCubit>(...);
   
   // ✅ Good - fresh instance per route
   sl.registerFactory<AuthCubit>(...);
   ```

---

## Migration Guide (If Using App-Level)

### Step 1: Identify Global vs Feature Cubits

**Global (App-Level):**
- `AppCubit` - Theme, language
- `NotificationCubit` - App-wide notifications
- `WorkoutTimerCubit` - If timer persists

**Feature (Route-Level):**
- `AuthCubit` - Login/logout
- `DashboardCubit` - Dashboard data
- `ProfileCubit` - User profile
- All other feature Cubits

### Step 2: Move Feature Cubits to Routes

```dart
// Before (app-level)
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => sl<AuthCubit>()),
    BlocProvider(create: (context) => sl<DashboardCubit>()),
  ],
  child: MaterialApp.router(...),
)

// After (route-level)
BlocProvider(
  create: (context) => sl<AppCubit>(), // Only global
  child: MaterialApp.router(...),
)

// In app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Moved here
    child: const LoginScreen(),
  ),
)
```

### Step 3: Ensure Factory Registration

```dart
// In feature_injection.dart
sl.registerFactory<FeatureCubit>(() => FeatureCubit(...)); // ✅ Factory
```

---

## Performance Comparison

| Approach | Memory Usage | Startup Time | State Management |
|----------|-------------|--------------|------------------|
| **App-Level (All)** | ❌ High (all Cubits) | ❌ Slow | ❌ Shared state |
| **Route-Level** | ✅ Low (only used) | ✅ Fast | ✅ Fresh state |
| **Hybrid** | ✅ Optimal | ✅ Fast | ✅ Best |

---

## Conclusion

**Recommended Approach:** Hybrid (App-Level + Route-Level)

1. **App-Level:** Only `AppCubit` (and truly global Cubits)
2. **Route-Level:** All feature-specific Cubits
3. **Factory Registration:** Use `registerFactory` for Cubits in DI

**Your Current Implementation:** ✅ Already following best practices!

The current project structure is optimal:
- `AppCubit` at app level (global state)
- Feature Cubits at route level (fresh instances)
- Factory registration in DI (proper lifecycle)

**The womenworld example has issues** - it creates all Cubits at app level, which is inefficient and can cause state management problems.
