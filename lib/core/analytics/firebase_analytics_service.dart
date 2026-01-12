//import 'package:firebase_analytics/firebase_analytics.dart';

import 'dart:developer';

/// A reusable Firebase Analytics Service that supports dynamic event names and parameters.
class FirebaseAnalyticsService {
  // final FirebaseAnalytics _analytics;
  //
  // FirebaseAnalyticsService(this._analytics);
  //
  // /// Logs an event dynamically.
  // ///
  // /// [eventName] — The event key (e.g., "post_liked")
  // /// [parameters] — Optional key-value pairs for event metadata.
  // Future<void> logEvent({
  //   required String eventName,
  //   Map<String, Object?>? parameters,
  // }) async {
  //   try {
  //     await _analytics.logEvent(
  //       name: eventName,
  //       parameters: parameters,
  //     );
  //     log('Firebase event logged: $eventName, params: $parameters');
  //   } catch (e) {
  //     log(' Error logging event [$eventName]: $e');
  //   }
  // }
  //
  // /// Logs screen views (optional but common for analytics)
  // Future<void> logScreen({
  //   required String screenName,
  //   String? screenClass,
  // }) async {
  //   await _analytics.logScreenView(
  //     screenName: screenName,
  //     screenClass: screenClass,
  //   );
  //   log('Screen logged: $screenName');
  // }
  //
  // /// Assigns a Firebase user ID
  // Future<void> setUserId(String userId) async {
  //   await _analytics.setUserId(id: userId);
  //   log('Firebase user ID set: $userId');
  // }
  //
  // /// Assigns a custom user property
  // Future<void> setUserProperty({
  //   required String name,
  //   required String value,
  // }) async {
  //   await _analytics.setUserProperty(name: name, value: value);
  //   log('User property set: $name = $value');
  // }
}
