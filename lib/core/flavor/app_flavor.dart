enum AppFlavor {
  development,
  staging,
  production;

  String get name {
    switch (this) {
      case AppFlavor.development:
        return 'Development';
      case AppFlavor.staging:
        return 'Staging';
      case AppFlavor.production:
        return 'Production';
    }
  }

  String get apiBaseUrl {
    switch (this) {
      case AppFlavor.development:
        return 'https://dev-api.example.development.com/api';
      case AppFlavor.staging:
        return 'https://staging-api.example.staging.com/api';
      case AppFlavor.production:
        return 'https://api.example.productioncom/api';
    }
  }

  String get appName {
    switch (this) {
      case AppFlavor.development:
        return 'Flutter Sample (Dev)';
      case AppFlavor.staging:
        return 'Flutter Sample (Staging)';
      case AppFlavor.production:
        return 'Flutter Sample Architecture';
    }
  }

  bool get enableLogging {
    switch (this) {
      case AppFlavor.development:
      case AppFlavor.staging:
        return true;
      case AppFlavor.production:
        return false;
    }
  }

  bool get enableDebugFeatures {
    switch (this) {
      case AppFlavor.development:
        return true;
      case AppFlavor.staging:
      case AppFlavor.production:
        return false;
    }
  }
}
