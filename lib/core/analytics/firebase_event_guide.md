# 📊 Firebase Analytics Integration Guide

This document explains how to initialize and use **Firebase Analytics** in your Flutter app with a reusable service class and dependency injection via **GetIt**.

---

## 🧱 1. Dependencies

Add these packages to your `pubspec.yamvl`:

```yaml
dependencies:
  firebase_core: ^3.0.0
  firebase_analytics: ^11.0.0
  get_it: ^7.7.0

⚙️ 2. Initialize Firebase

In your main.dart file:

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initServiceLocator();
  runApp(MyApp());
}

🧩 3. Setup Service Locator

File: lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:your_app/analytics/firebase_analytics_service.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  sl.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);

  sl.registerLazySingleton<FirebaseAnalyticsService>(
    () => FirebaseAnalyticsService(sl<FirebaseAnalytics>()),
  );
}

🧠 4. Create Analytics Service

File: lib/analytics/firebase_analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  /// Logs a Firebase Analytics event dynamically.
  Future<void> logFirebaseEvent(
    String eventName, [
    Map<String, Object?>? parameters,
  ]) async {
    try {
      await _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      );
      print('✅ Firebase event logged: $eventName → $parameters');
    } catch (e) {
      print('❌ Failed to log event "$eventName": $e');
    }
  }

  /// Logs screen views
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
    print('📱 Screen logged: $screenName');
  }

  /// Assigns a user ID for tracking
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    print('👤 User ID set: $userId');
  }

  /// Sets user property (e.g. role, plan type)
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
    print('🏷️ User property set: $name = $value');
  }
}

🚀 5. Usage Examples
✅ Log an event
import 'package:your_app/core/di/service_locator.dart';
import 'package:your_app/analytics/firebase_analytics_service.dart';

void onPostLiked(String postId, String userId) {
  sl<FirebaseAnalyticsService>().logFirebaseEvent('post_liked', {
    'post_id': postId,
    'user_id': userId,
  });
}

✅ Log screen view
sl<FirebaseAnalyticsService>().logScreenView(
  screenName: 'MarketplaceScreen',
  screenClass: 'MarketplacePage',
);

✅ Set user ID
sl<FirebaseAnalyticsService>().setUserId('user_789');

✅ Set user property
sl<FirebaseAnalyticsService>().setUserProperty(
  name: 'membership',
  value: 'premium',
);

🧩 6. (Optional) Event Key Constants

Keep all your event names organized in one place:

File: lib/analytics/firebase_event_keys.dart

class FirebaseEventKeys {
  static const postLiked = 'post_liked';
  static const postCreated = 'post_created';
  static const signup = 'signup';
  static const login = 'login';
}


Usage:

sl<FirebaseAnalyticsService>().logFirebaseEvent(
  FirebaseEventKeys.signup,
  {'method': 'email'},
);

🧾 Summary

✅ One-time setup for analytics
✅ Centralized, reusable logging
✅ Type-safe with event keys
✅ Works across the app via get_it
✅ Supports screen tracking, user IDs, and custom properties