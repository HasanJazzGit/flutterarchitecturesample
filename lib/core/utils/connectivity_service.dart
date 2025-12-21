import 'package:connectivity_plus/connectivity_plus.dart';

/// Service to check network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device has internet connection
  Future<bool> hasInternetConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Get current connectivity status
  Future<ConnectivityResult> getCurrentConnectivity() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      return ConnectivityResult.none;
    }
  }
}
