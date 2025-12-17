/// App enums for state management
library app_enums;

/// App lifecycle state enum
/// Represents the current state of the application
enum AppState {
  /// App is initializing (e.g., loading initial data, setting up services)
  initializing,

  /// App is ready and running normally
  ready,

  /// App is in the background (paused)
  background,

  /// App is in the foreground (resumed)
  foreground,

  /// App is being terminated
  terminating,

  /// App encountered an error state
  error;

  /// Get a human-readable name for the state
  String get name {
    switch (this) {
      case AppState.initializing:
        return 'Initializing';
      case AppState.ready:
        return 'Ready';
      case AppState.background:
        return 'Background';
      case AppState.foreground:
        return 'Foreground';
      case AppState.terminating:
        return 'Terminating';
      case AppState.error:
        return 'Error';
    }
  }

  /// Check if app is in an active state (ready or foreground)
  bool get isActive => this == AppState.ready || this == AppState.foreground;

  /// Check if app is in an inactive state (background or terminating)
  bool get isInactive =>
      this == AppState.background ||
      this == AppState.terminating ||
      this == AppState.initializing;

  /// Check if app is ready for user interaction
  bool get isReady => this == AppState.ready;
}
