# 🧭 GoRouter Navigation Guide

Complete guide for using GoRouter in Flutter - adding routes, navigation methods, parameters, logging, and best practices.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Router Setup](#router-setup)
3. [Adding New Routes](#adding-new-routes)
4. [Navigation Methods](#navigation-methods)
5. [Passing Parameters](#passing-parameters)
6. [Route Logging](#route-logging)
7. [Advanced Features](#advanced-features)
8. [Best Practices](#best-practices)
9. [Common Patterns](#common-patterns)
10. [Troubleshooting](#troubleshooting)

---

## 📖 Overview

**GoRouter** is a declarative routing solution for Flutter that provides:
- ✅ Type-safe navigation
- ✅ Deep linking support
- ✅ URL-based routing
- ✅ Navigation logging
- ✅ Route guards/redirects

### File Structure

```
lib/core/router/
├── app_router.dart          # Router configuration
├── app_routes.dart          # Route constants
└── router_observer.dart     # Navigation logging
```

---

## ⚙️ Router Setup

### Current Router Configuration

The router is configured in `lib/core/router/app_router.dart`:

```dart
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [GoRouterObserver()], // Debug logging
    routes: [
      // Routes defined here
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
```

### Route Constants

Routes are defined in `lib/core/router/app_routes.dart`:

```dart
class AppRoutes {
  AppRoutes._(); // Private constructor

  // Route constants (without leading "/")
  static const String splash = 'splash';
  static const String login = 'login';
  static const String examples = 'examples';
  // ... more routes

  /// Get route path with leading "/"
  static String path(String route) {
    return route.isEmpty ? '/' : '/$route';
  }
}
```

---

## ➕ Adding New Routes

### Step-by-Step Guide

#### Step 1: Add Route Constant

In `lib/core/router/app_routes.dart`, add your route constant:

```dart
class AppRoutes {
  // ... existing routes

  // Add your new route
  static const String myNewPage = 'my-new-page';
  
  // For nested routes
  static const String myNewPageDetails = 'my-new-page/details';
}
```

#### Step 2: Create Your Page Widget

Create your page widget in the appropriate feature folder:

```dart
// lib/features/my_feature/presentation/pages/my_new_page.dart
import 'package:flutter/material.dart';

class MyNewPage extends StatelessWidget {
  const MyNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My New Page')),
      body: const Center(child: Text('My New Page Content')),
    );
  }
}
```

#### Step 3: Add Route to Router

In `lib/core/router/app_router.dart`, add your route:

```dart
import '../../features/my_feature/presentation/pages/my_new_page.dart'; // Add import

class AppRouter {
  static final GoRouter router = GoRouter(
    // ... existing config
    routes: [
      // ... existing routes
      
      // Add your new route
      GoRoute(
        path: AppRoutes.path(AppRoutes.myNewPage),
        name: AppRoutes.myNewPage,
        builder: (context, state) => const MyNewPage(),
      ),
      
      // Add more routes here as needed
    ],
  );
}
```

#### Step 4: Navigate to Your Route

Use navigation methods (see [Navigation Methods](#navigation-methods)):

```dart
// Navigate to your new page
context.push(AppRoutes.path(AppRoutes.myNewPage));
```

### Complete Example

**1. Route Constant:**
```dart
// app_routes.dart
static const String userProfile = 'user-profile';
```

**2. Page Widget:**
```dart
// user_profile_page.dart
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: const Center(child: Text('Profile Content')),
    );
  }
}
```

**3. Router Configuration:**
```dart
// app_router.dart
import '../../features/user/presentation/pages/user_profile_page.dart';

GoRoute(
  path: AppRoutes.path(AppRoutes.userProfile),
  name: AppRoutes.userProfile,
  builder: (context, state) => const UserProfilePage(),
),
```

**4. Navigation:**
```dart
// Navigate from anywhere
context.push(AppRoutes.path(AppRoutes.userProfile));
```

---

## 🚀 Navigation Methods

### 1. `context.push()` - Push New Route

**Pushes a new route onto the navigation stack** (can go back).

```dart
// Basic push
context.push(AppRoutes.path(AppRoutes.examples));

// Push with extra data
context.push(
  AppRoutes.path(AppRoutes.userDetails),
  extra: {'userId': 123, 'name': 'John'},
);

// Push with query parameters
context.push(
  '${AppRoutes.path(AppRoutes.userDetails)}?id=123&name=John',
);
```

**When to use:**
- ✅ Navigating to a detail page
- ✅ User can go back
- ✅ Adding to navigation stack

**Example:**
```dart
// Navigate to product details
onTap: () {
  context.push(AppRoutes.path(AppRoutes.productDetails));
}
```

### 2. `context.go()` - Replace Current Route

**Replaces the current route** (cannot go back to previous route).

```dart
// Replace current route
context.go(AppRoutes.path(AppRoutes.login));

// Go with query parameters
context.go('${AppRoutes.path(AppRoutes.home)}?tab=settings');
```

**When to use:**
- ✅ Login/logout navigation
- ✅ Replacing entire navigation stack
- ✅ Deep linking
- ✅ Initial navigation

**Example:**
```dart
// After logout, go to login (replace stack)
Future<void> logout() async {
  await authRepository.logout();
  if (context.mounted) {
    context.go(AppRoutes.path(AppRoutes.login));
  }
}
```

### 3. `context.pop()` - Pop Current Route

**Pops the current route from the navigation stack** (goes back).

```dart
// Basic pop
context.pop();

// Pop with result
context.pop({'result': 'success', 'data': 123});

// Pop with boolean
context.pop(true);
```

**When to use:**
- ✅ Going back to previous screen
- ✅ Closing dialogs/modals
- ✅ Returning with data

**Example:**
```dart
// Back button
IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () => context.pop(),
)

// Save and return
ElevatedButton(
  onPressed: () {
    // Save data
    saveData();
    context.pop({'saved': true});
  },
  child: const Text('Save'),
)
```

### 4. `context.pushReplacement()` - Replace and Push

**Replaces current route and pushes new route** (removes current, adds new).

```dart
// Replace and push
context.pushReplacement(AppRoutes.path(AppRoutes.dashboard));
```

**When to use:**
- ✅ After login (replace login with dashboard)
- ✅ Moving to main app flow
- ✅ Don't want user to go back

**Example:**
```dart
// After successful login
result.fold(
  (error) => showError(error),
  (user) {
    // Replace login with dashboard
    context.pushReplacement(AppRoutes.path(AppRoutes.dashboard));
  },
);
```

### 5. `context.pushReplacementNamed()` - Replace with Named Route

**Replaces current route using route name** (alternative to pushReplacement).

```dart
// Replace with named route
context.pushReplacementNamed(AppRoutes.examples);
```

**When to use:**
- ✅ Same as pushReplacement but using route name
- ✅ Prefer route names over paths

**Example:**
```dart
// After login
if (context.mounted) {
  context.pushReplacementNamed(AppRoutes.examples);
}
```

### 6. `context.canPop()` - Check if Can Pop

**Checks if current route can be popped** (has previous route).

```dart
// Check if can go back
if (context.canPop()) {
  context.pop();
} else {
  // No previous route, navigate to home
  context.go(AppRoutes.path(AppRoutes.home));
}
```

**When to use:**
- ✅ Prevent back navigation on root screen
- ✅ Custom back button behavior
- ✅ Exit app logic

**Example:**
```dart
// Custom back button
WillPopScope(
  onWillPop: () async {
    if (context.canPop()) {
      context.pop();
      return false;
    }
    // Exit app or navigate to home
    return true;
  },
  child: YourWidget(),
)
```

### Navigation Methods Summary

| Method | Purpose | Can Go Back? | Use Case |
|--------|---------|--------------|----------|
| `push()` | Add new route | ✅ Yes | Detail pages |
| `go()` | Replace route | ❌ No | Login/logout |
| `pop()` | Remove current | ✅ Yes | Back button |
| `pushReplacement()` | Replace + push | ❌ No | After login |
| `pushReplacementNamed()` | Replace (named) | ❌ No | After login |
| `canPop()` | Check if can pop | - | Back button logic |

---

## 📦 Passing Parameters

### Method 1: Path Parameters (URL Segments)

**Define route with parameter:**
```dart
// app_routes.dart
static const String userDetails = 'user/:userId';

// app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.userDetails), // '/user/:userId'
  name: AppRoutes.userDetails,
  builder: (context, state) {
    // Extract parameter
    final userId = state.pathParameters['userId']!;
    return UserDetailsPage(userId: userId);
  },
),
```

**Navigate with parameter:**
```dart
// Navigate with path parameter
context.push('/user/123'); // userId = '123'

// Or using route constant
context.push('${AppRoutes.path(AppRoutes.userDetails).replaceAll(':userId', '123')}');
```

**Access parameter in page:**
```dart
class UserDetailsPage extends StatelessWidget {
  final String userId;

  const UserDetailsPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId')),
      body: Text('User ID: $userId'),
    );
  }
}
```

### Method 2: Query Parameters (URL Query String)

**Define route (no changes needed):**
```dart
// app_routes.dart
static const String search = 'search';

// app_router.dart
GoRoute(
  path: AppRoutes.path(AppRoutes.search),
  name: AppRoutes.search,
  builder: (context, state) {
    // Extract query parameters
    final query = state.uri.queryParameters['q'] ?? '';
    final category = state.uri.queryParameters['category'] ?? '';
    return SearchPage(query: query, category: category);
  },
),
```

**Navigate with query parameters:**
```dart
// Navigate with query parameters
context.push('/search?q=flutter&category=mobile');

// Or build URL
final searchUrl = Uri(
  path: AppRoutes.path(AppRoutes.search),
  queryParameters: {
    'q': 'flutter',
    'category': 'mobile',
  },
).toString();
context.push(searchUrl);
```

**Access query parameters:**
```dart
class SearchPage extends StatelessWidget {
  final String query;
  final String category;

  const SearchPage({
    required this.query,
    required this.category,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search: $query')),
      body: Text('Category: $category'),
    );
  }
}
```

### Method 3: Extra Data (Object)

**Pass complex objects** (not in URL):

```dart
// Define route (no changes needed)
GoRoute(
  path: AppRoutes.path(AppRoutes.productDetails),
  name: AppRoutes.productDetails,
  builder: (context, state) {
    // Extract extra data
    final product = state.extra as Product?;
    return ProductDetailsPage(product: product);
  },
),
```

**Navigate with extra data:**
```dart
// Navigate with object
final product = Product(id: 1, name: 'Flutter Book', price: 29.99);

context.push(
  AppRoutes.path(AppRoutes.productDetails),
  extra: product,
);

// Or with map
context.push(
  AppRoutes.path(AppRoutes.productDetails),
  extra: {
    'id': 1,
    'name': 'Flutter Book',
    'price': 29.99,
  },
);
```

**Access extra data:**
```dart
class ProductDetailsPage extends StatelessWidget {
  final Product? product;

  const ProductDetailsPage({this.product, super.key});

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(body: Center(child: Text('Product not found')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(product!.name)),
      body: Text('Price: \$${product!.price}'),
    );
  }
}
```

### Method 4: Multiple Parameters

**Combine path and query parameters:**
```dart
// Route: /user/:userId/posts?filter=recent
GoRoute(
  path: '/user/:userId/posts',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    final filter = state.uri.queryParameters['filter'] ?? 'all';
    return UserPostsPage(userId: userId, filter: filter);
  },
),

// Navigate
context.push('/user/123/posts?filter=recent');
```

### Parameter Methods Comparison

| Method | URL Visible | Type Safety | Use Case |
|--------|-------------|-------------|----------|
| Path Parameters | ✅ Yes | ⚠️ String only | IDs, slugs |
| Query Parameters | ✅ Yes | ⚠️ String only | Filters, search |
| Extra Data | ❌ No | ✅ Type-safe | Complex objects |

---

## 📊 Route Logging

### Router Observer

The router automatically logs all navigation events using `GoRouterObserver`.

**Location:** `lib/core/router/router_observer.dart`

**What gets logged:**
- 🚀 **PUSH** - When a new route is pushed
- ⬅️ **POP** - When a route is popped
- 🗑️ **REMOVE** - When a route is removed
- 🔄 **REPLACE** - When a route is replaced

### Log Output Example

```
┌─────────────────────────────────────────────────────────────
│ 🚀 ROUTER: PUSH
├─────────────────────────────────────────────────────────────
│ From: splash
│ To: login
└─────────────────────────────────────────────────────────────
```

### Enabling/Disabling Logging

**Logging is automatically enabled in debug mode:**

```dart
// router_observer.dart
void _logRouteChange(...) {
  if (kDebugMode) {  // Only logs in debug mode
    _logger.d(...);
  }
}
```

**To disable logging:**
```dart
// app_router.dart
static final GoRouter router = GoRouter(
  // Remove observer
  // observers: [GoRouterObserver()], // Comment out to disable
  routes: [...],
);
```

**To customize logging:**
```dart
// router_observer.dart
void _logRouteChange(...) {
  if (kDebugMode) {
    // Add custom logging logic
    _logger.d('Custom log: $action from $from to $to');
  }
}
```

---

## 🔧 Advanced Features

### 1. Route Redirects

**Redirect based on conditions:**

```dart
GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.path(AppRoutes.root),
      redirect: (context, state) => AppRoutes.path(AppRoutes.splash),
    ),
    // ... more routes
  ],
  // Global redirect
  redirect: (context, state) {
    final isLoggedIn = checkAuthStatus();
    final isGoingToLogin = state.uri.path == AppRoutes.path(AppRoutes.login);
    
    // Redirect to login if not authenticated
    if (!isLoggedIn && !isGoingToLogin) {
      return AppRoutes.path(AppRoutes.login);
    }
    
    // Redirect to home if already logged in and going to login
    if (isLoggedIn && isGoingToLogin) {
      return AppRoutes.path(AppRoutes.home);
    }
    
    return null; // No redirect
  },
);
```

### 2. Nested Routes

**Create nested navigation:**

```dart
GoRoute(
  path: AppRoutes.path(AppRoutes.settings),
  builder: (context, state) => const SettingsPage(),
  routes: [
    // Nested routes
    GoRoute(
      path: 'profile',
      builder: (context, state) => const ProfileSettingsPage(),
    ),
    GoRoute(
      path: 'notifications',
      builder: (context, state) => const NotificationSettingsPage(),
    ),
  ],
),

// Navigate to nested route
context.push('/settings/profile');
context.push('/settings/notifications');
```

### 3. Route Guards

**Protect routes with authentication:**

```dart
GoRoute(
  path: AppRoutes.path(AppRoutes.dashboard),
  redirect: (context, state) {
    final isAuthenticated = checkAuth();
    if (!isAuthenticated) {
      return AppRoutes.path(AppRoutes.login);
    }
    return null; // Allow access
  },
  builder: (context, state) => const DashboardPage(),
),
```

### 4. Error Handling

**Custom error page:**

```dart
GoRouter(
  routes: [...],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.path(AppRoutes.home)),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
```

### 5. Deep Linking

**Handle deep links:**

```dart
// Deep link: myapp://product/123
GoRoute(
  path: '/product/:id',
  builder: (context, state) {
    final productId = state.pathParameters['id']!;
    return ProductDetailsPage(productId: productId);
  },
),

// Navigate to deep link
context.go('/product/123');
```

---

## ✅ Best Practices

### 1. **Use Route Constants**

```dart
// ✅ Good - Use constants
context.push(AppRoutes.path(AppRoutes.login));

// ❌ Bad - Hardcoded strings
context.push('/login');
```

### 2. **Check Context Mounted**

```dart
// ✅ Good - Check before navigation
if (context.mounted) {
  context.push(AppRoutes.path(AppRoutes.home));
}

// ❌ Bad - Navigation after dispose
context.push(AppRoutes.path(AppRoutes.home)); // Might fail
```

### 3. **Use Appropriate Navigation Method**

```dart
// ✅ Good - Use go() for login/logout
context.go(AppRoutes.path(AppRoutes.login));

// ✅ Good - Use push() for detail pages
context.push(AppRoutes.path(AppRoutes.productDetails));

// ❌ Bad - Wrong method
context.push(AppRoutes.path(AppRoutes.login)); // Should use go()
```

### 4. **Handle Parameters Safely**

```dart
// ✅ Good - Null-safe parameter access
final userId = state.pathParameters['userId'];
if (userId == null) {
  return const ErrorPage(message: 'User ID required');
}
return UserDetailsPage(userId: userId);

// ❌ Bad - Force unwrap
final userId = state.pathParameters['userId']!; // Might crash
```

### 5. **Use Type-Safe Extra Data**

```dart
// ✅ Good - Type-safe
final product = state.extra as Product?;
if (product == null) {
  return const ErrorPage();
}

// ❌ Bad - Unsafe cast
final product = state.extra as Product; // Might crash
```

### 6. **Organize Routes by Feature**

```dart
// ✅ Good - Group related routes
// Auth routes
GoRoute(path: '/login', ...),
GoRoute(path: '/register', ...),

// Product routes
GoRoute(path: '/products', ...),
GoRoute(path: '/product/:id', ...),
```

---

## 🔄 Common Patterns

### Pattern 1: Login Flow

```dart
// After successful login
result.fold(
  (error) => showError(error),
  (user) {
    // Replace login with dashboard
    if (context.mounted) {
      context.pushReplacementNamed(AppRoutes.dashboard);
    }
  },
);
```

### Pattern 2: Detail Page Navigation

```dart
// Navigate to detail page
onTap: () {
  context.push(
    AppRoutes.path(AppRoutes.productDetails),
    extra: product,
  );
}
```

### Pattern 3: Back with Result

```dart
// Save and return
ElevatedButton(
  onPressed: () {
    final result = saveData();
    context.pop(result);
  },
  child: const Text('Save'),
)

// Receive result
final result = await Navigator.push(...);
if (result != null) {
  // Handle result
}
```

### Pattern 4: Conditional Navigation

```dart
// Navigate based on condition
if (isLoggedIn) {
  context.go(AppRoutes.path(AppRoutes.dashboard));
} else {
  context.go(AppRoutes.path(AppRoutes.login));
}
```

### Pattern 5: Navigation with Loading

```dart
// Show loading, then navigate
showLoadingDialog();
try {
  await performAction();
  if (context.mounted) {
    Navigator.pop(context); // Close loading
    context.push(AppRoutes.path(AppRoutes.success));
  }
} catch (e) {
  if (context.mounted) {
    Navigator.pop(context); // Close loading
    showError(e.toString());
  }
}
```

---

## 🐛 Troubleshooting

### Issue 1: Route Not Found

**Problem:**
```
Page not found: /my-route
```

**Solution:**
1. Check route is defined in `app_router.dart`
2. Verify route path matches exactly
3. Check route constant in `app_routes.dart`

```dart
// ✅ Ensure route exists
GoRoute(
  path: AppRoutes.path(AppRoutes.myRoute), // Must match
  name: AppRoutes.myRoute,
  builder: (context, state) => MyPage(),
),
```

### Issue 2: Parameter Not Found

**Problem:**
```
Parameter 'userId' is null
```

**Solution:**
```dart
// ✅ Null-safe access
final userId = state.pathParameters['userId'];
if (userId == null) {
  return const ErrorPage();
}
```

### Issue 3: Navigation After Dispose

**Problem:**
```
Navigator operation requested with a context that does not include a Navigator.
```

**Solution:**
```dart
// ✅ Check mounted before navigation
if (context.mounted) {
  context.push(AppRoutes.path(AppRoutes.home));
}
```

### Issue 4: Deep Link Not Working

**Problem:**
Deep links not navigating correctly.

**Solution:**
1. Verify route path matches deep link
2. Check route parameters
3. Ensure route is defined correctly

```dart
// ✅ Match deep link format
// Deep link: myapp://user/123
GoRoute(
  path: '/user/:userId', // Matches /user/123
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserPage(userId: userId);
  },
),
```

### Issue 5: Can't Go Back

**Problem:**
Back button doesn't work.

**Solution:**
```dart
// ✅ Check if can pop
if (context.canPop()) {
  context.pop();
} else {
  // Navigate to home or exit
  context.go(AppRoutes.path(AppRoutes.home));
}
```

---

## 📋 Quick Reference

### Navigation Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `push()` | Add route | `context.push('/page')` |
| `go()` | Replace route | `context.go('/page')` |
| `pop()` | Remove route | `context.pop()` |
| `pushReplacement()` | Replace + push | `context.pushReplacement('/page')` |
| `canPop()` | Check if can pop | `context.canPop()` |

### Parameter Types

| Type | Access | Example |
|------|--------|---------|
| Path | `state.pathParameters['key']` | `/user/:id` |
| Query | `state.uri.queryParameters['key']` | `/search?q=term` |
| Extra | `state.extra` | `context.push('/page', extra: data)` |

### File Locations

- **Router Config**: `lib/core/router/app_router.dart`
- **Route Constants**: `lib/core/router/app_routes.dart`
- **Router Observer**: `lib/core/router/router_observer.dart`

---

## ✅ Checklist

When adding a new route:

- [ ] Add route constant to `app_routes.dart`
- [ ] Create page widget
- [ ] Add route to `app_router.dart`
- [ ] Import page in `app_router.dart`
- [ ] Test navigation
- [ ] Check route logging
- [ ] Handle parameters safely
- [ ] Add error handling if needed

---

## 🎯 Summary

1. ✅ **Add Route**: Constant → Page → Router → Navigate
2. ✅ **Navigation**: Use `push()` for details, `go()` for login/logout
3. ✅ **Parameters**: Path (URL), Query (URL), Extra (object)
4. ✅ **Logging**: Automatic via `GoRouterObserver`
5. ✅ **Best Practices**: Use constants, check mounted, handle nulls
6. ✅ **Common Patterns**: Login flow, detail pages, back with result

---

**Why GoRouter?** It provides **type-safe, URL-based navigation** with **deep linking support** and **automatic logging** - perfect for modern Flutter apps!
