# Lazy Loading Cubits: Complete Guide

## Understanding Lazy Loading

### Current Approach (Already Lazy!) ✅

Your current implementation **already uses lazy loading** at the DI level:

```dart
// main.dart
void main() async {
  await initDependencyInjection(); // ✅ Registers factories (lazy)
  runApp(const FlutterSampleApp());
}

// auth_injection.dart
sl.registerFactory<AuthCubit>(() => AuthCubit(sl<LoginUseCase>())); 
// ✅ Factory function registered, but instance NOT created yet

// app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // ✅ Created only when route accessed
    child: const LoginScreen(),
  ),
)
```

**What happens:**
1. ✅ **main()**: Registers factory functions (no instances created)
2. ✅ **Route accessed**: `sl<AuthCubit>()` creates instance (lazy)
3. ✅ **Route disposed**: Instance is garbage collected

---

## Three Levels of Lazy Loading

### 1. **DI Registration (Already Lazy)** ✅

```dart
// In main() - Registers factory functions only
await initDependencyInjection();

// auth_injection.dart
sl.registerFactory<AuthCubit>(() => AuthCubit(...));
// ✅ Just registers a function, doesn't create instance
```

**Status:** ✅ Already lazy - no instances created at registration

---

### 2. **Provider Creation (Current: Route-Level)** ✅

```dart
// app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // ✅ Created when route accessed
    child: const LoginScreen(),
  ),
)
```

**Status:** ✅ Lazy - instance created only when route is navigated to

---

### 3. **Alternative: App-Level with Lazy Singleton** ⚠️

```dart
// auth_injection.dart
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...)); // ⚠️ Lazy singleton

// flutter_sample_app.dart
BlocProvider.value(
  value: sl<AuthCubit>(), // ⚠️ Created when app starts (first access)
  child: MaterialApp.router(...),
)
```

**Status:** ⚠️ Partially lazy - created on first access, but shared across routes

---

## Comparison: Current vs App-Level Lazy

### Current Approach (Route-Level + Factory) ✅

```dart
// DI Registration (main)
sl.registerFactory<AuthCubit>(() => AuthCubit(...));

// Route-Level Provider
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Fresh instance per route
    child: const LoginScreen(),
  ),
)
```

**Timeline:**
```
App Start → Registers factory (0ms)
User navigates to /login → Creates AuthCubit instance (lazy)
User navigates away → Instance disposed
User navigates to /login again → New fresh instance
```

**Benefits:**
- ✅ True lazy loading (created when needed)
- ✅ Fresh state per route
- ✅ Memory efficient (disposed when route removed)
- ✅ No shared state issues

---

### App-Level with Lazy Singleton ⚠️

```dart
// DI Registration (main)
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...));

// App-Level Provider
BlocProvider.value(
  value: sl<AuthCubit>(), // Created on first access
  child: MaterialApp.router(...),
)
```

**Timeline:**
```
App Start → Registers lazy singleton (0ms)
First BlocProvider.value access → Creates AuthCubit instance (lazy)
User navigates away → Instance persists (not disposed)
User navigates to /login again → Same instance (shared state)
```

**Problems:**
- ⚠️ Shared state across routes (login form keeps old data)
- ⚠️ Instance never disposed (memory leak potential)
- ⚠️ Not truly lazy after first access

---

## Best Approach: Hybrid with True Lazy Loading

### Recommended: Current Approach (Route-Level + Factory) ✅

```dart
// ✅ Step 1: Register in main() (lazy registration)
void main() async {
  await initDependencyInjection(); // Registers factories only
  runApp(const FlutterSampleApp());
}

// ✅ Step 2: Use route-level providers (lazy creation)
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // Created when route accessed
    child: const LoginScreen(),
  ),
)
```

**Why this is best:**
1. ✅ **Lazy Registration**: Factory functions registered in main (no instances)
2. ✅ **Lazy Creation**: Instance created only when route accessed
3. ✅ **Fresh State**: New instance per route
4. ✅ **Memory Efficient**: Disposed when route removed

---

## Alternative: App-Level with Lazy Singleton (Not Recommended)

If you want app-level providers with lazy loading:

```dart
// ⚠️ Not recommended - has issues
// auth_injection.dart
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...));

// flutter_sample_app.dart
MultiBlocProvider(
  providers: [
    BlocProvider.value(value: sl<AuthCubit>()), // Created on first access
    BlocProvider.value(value: sl<DashboardCubit>()),
    // ... more
  ],
  child: MaterialApp.router(...),
)
```

**Issues:**
- ❌ Shared state (login form keeps old data)
- ❌ Instances persist (not disposed)
- ❌ Not truly lazy after first access

---

## Understanding GetIt Registration Types

### `registerFactory` (Current - Best for Cubits) ✅

```dart
sl.registerFactory<AuthCubit>(() => AuthCubit(...));
```

**Behavior:**
- Creates new instance every time `sl<AuthCubit>()` is called
- No instance created at registration
- Perfect for Cubits (fresh state per route)

**When to use:** Cubits, BLoCs, stateful widgets

---

### `registerLazySingleton` (For Services) ✅

```dart
sl.registerLazySingleton<AuthRepository>(() => AuthRepository(...));
```

**Behavior:**
- Creates instance on first `sl<AuthRepository>()` call
- Reuses same instance for subsequent calls
- Instance persists until app closes

**When to use:** Repositories, Data Sources, Use Cases, Services

---

### `registerSingleton` (Immediate - Rare) ⚠️

```dart
sl.registerSingleton<AppConfig>(AppConfig());
```

**Behavior:**
- Creates instance immediately at registration
- Not lazy at all

**When to use:** Simple config objects, constants

---

## Performance Comparison

### Scenario: User never visits login screen

| Approach | Memory at Startup | Memory After Login | State Management |
|----------|------------------|-------------------|------------------|
| **Current (Route-Level + Factory)** | ✅ 0 KB (not created) | ✅ ~5 KB (created) | ✅ Fresh state |
| **App-Level + Lazy Singleton** | ✅ 0 KB (not created) | ⚠️ ~5 KB (persists) | ❌ Shared state |
| **App-Level + Factory** | ❌ ~100 KB (all created) | ❌ ~100 KB (all persist) | ❌ Shared state |

---

## Code Examples

### ✅ Current Approach (Recommended)

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection(); // ✅ Lazy registration
  runApp(const FlutterSampleApp());
}

// auth_injection.dart
void initAuthInjector() {
  // ... register dependencies
  sl.registerFactory<AuthCubit>(() => AuthCubit(...)); // ✅ Factory
}

// app_router.dart
GoRoute(
  path: '/login',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<AuthCubit>(), // ✅ Lazy creation
    child: const LoginScreen(),
  ),
)
```

**Result:** ✅ True lazy loading - created only when route accessed

---

### ⚠️ App-Level with Lazy Singleton (Alternative)

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection(); // ✅ Lazy registration
  runApp(const FlutterSampleApp());
}

// auth_injection.dart
void initAuthInjector() {
  // ... register dependencies
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...)); // ⚠️ Lazy singleton
}

// flutter_sample_app.dart
MultiBlocProvider(
  providers: [
    BlocProvider.value(value: sl<AuthCubit>()), // ⚠️ Created on first access
  ],
  child: MaterialApp.router(...),
)
```

**Result:** ⚠️ Partially lazy - created on first access, but shared state issues

---

## When to Use Each Approach

### Use Route-Level + Factory (Current) ✅

**For:**
- Feature-specific Cubits (`AuthCubit`, `DashboardCubit`, `ProductsCubit`)
- Cubits that need fresh state per route
- Most Cubits in your app

**Benefits:**
- ✅ True lazy loading
- ✅ Fresh state per route
- ✅ Memory efficient

---

### Use App-Level + Lazy Singleton ⚠️

**For:**
- Truly global state (`AppCubit` - theme, language)
- Services that need to persist across routes
- Rare cases where shared state is desired

**Example:**
```dart
// ✅ Good use case
sl.registerLazySingleton<AppCubit>(() => AppCubit(...));

BlocProvider.value(
  value: sl<AppCubit>(), // Theme/language - needed everywhere
  child: MaterialApp.router(...),
)
```

---

## Answer to Your Question

> "What if I initialize in main from start but lazy load - is it a best approach?"

### Current Approach (Already Best) ✅

**What you're doing:**
1. ✅ Initialize DI in main() (registers factories - lazy)
2. ✅ Use route-level providers (creates when needed - lazy)
3. ✅ Use `registerFactory` for Cubits (fresh instances)

**This IS lazy loading!** ✅

- DI registration in main: ✅ Lazy (just registers functions)
- Provider creation: ✅ Lazy (created when route accessed)
- Instance lifecycle: ✅ Efficient (disposed when route removed)

---

### Alternative (Not Recommended) ❌

**If you want app-level with lazy singleton:**

```dart
// main.dart - Same
await initDependencyInjection();

// auth_injection.dart - Change to lazy singleton
sl.registerLazySingleton<AuthCubit>(() => AuthCubit(...)); // ⚠️

// flutter_sample_app.dart - App-level
BlocProvider.value(
  value: sl<AuthCubit>(), // ⚠️ Created on first access
  child: MaterialApp.router(...),
)
```

**Problems:**
- ❌ Shared state (login form keeps old data)
- ❌ Instance persists (not disposed)
- ❌ Not truly lazy after first access

---

## Conclusion

### ✅ Your Current Approach is Best!

**You're already using lazy loading:**
1. ✅ DI registration in main (lazy - just registers functions)
2. ✅ Route-level providers (lazy - creates when route accessed)
3. ✅ Factory registration (fresh instances)

**No changes needed!** Your implementation is optimal.

**If you want app-level providers:**
- Use only for truly global state (`AppCubit`)
- Keep feature Cubits at route level
- This maintains lazy loading while avoiding shared state issues

---

## Summary Table

| Aspect | Current (Route-Level) | App-Level + Lazy Singleton |
|--------|----------------------|---------------------------|
| **DI Registration** | ✅ Lazy (factory) | ✅ Lazy (lazy singleton) |
| **Instance Creation** | ✅ When route accessed | ⚠️ On first access |
| **State Management** | ✅ Fresh per route | ❌ Shared across routes |
| **Memory** | ✅ Disposed when route removed | ⚠️ Persists until app closes |
| **Best For** | Feature Cubits | Global state only |

**Recommendation:** ✅ Keep current approach - it's already optimal!
