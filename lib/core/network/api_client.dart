import 'package:dio/dio.dart';
import '../di/dependency_injection.dart';
import '../preference/app_pref.dart';
import 'api_logger_interceptor.dart';

/// API Client configuration
class ApiClientConfig {
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final int maxRetries;
  final Duration retryDelay;
  final bool enableLogging;

  const ApiClientConfig({
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.maxRetries = 0,
    this.retryDelay = const Duration(seconds: 1),
    this.enableLogging = true,
  });
}

class ApiClient {

  final Dio dio;
  final Map<String, String> defaultHeaders;
  final ApiClientConfig config;

  ApiClient({
    Dio? dio,
    Map<String, String>? defaultHeaders,
    ApiClientConfig? config,
  }) : config = config ?? const ApiClientConfig(),
       defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'},
       dio =
           dio ??
           Dio(
             BaseOptions(
               headers:
                   defaultHeaders ??
                   {
                     'Content-Type': 'application/json',
                     'Accept': 'application/json',
                   },
               connectTimeout:
                   config?.connectTimeout ?? const Duration(seconds: 30),
               receiveTimeout:
                   config?.receiveTimeout ?? const Duration(seconds: 30),
               sendTimeout: config?.sendTimeout ?? const Duration(seconds: 30),
             ),
           ) {
    // Add logger interceptor if logging is enabled
    if (this.config.enableLogging) {
      this.dio.interceptors.add(ApiLoggerInterceptor());
    }

    // Best Practice: Automatically set auth token if available
    _loadAuthToken();

  }

  /// Load authentication token from shared preferences
  /// Best Practice: Automatically include token in API requests
  void _loadAuthToken() {
    try {
      final token = sl<AppPref>().getToken();
      if (token.isNotEmpty) {
        setAuthToken(token);
      }
    } catch (e) {
      // AppPref not initialized yet, skip token loading
    }
  }

  /// GET request with retry support
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeWithRetry(
      () => dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(options, headers: headers),
        cancelToken: cancelToken,
      ),
      'GET',
    );
  }

  /// POST request with retry support
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeWithRetry(
      () => dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: _mergeOptions(options, headers: headers),
        cancelToken: cancelToken,
      ),
      'POST',
    );
  }

  /// PUT request with retry support
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeWithRetry(
      () => dio.put<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: _mergeOptions(options, headers: headers),
        cancelToken: cancelToken,
      ),
      'PUT',
    );
  }

  /// PATCH request with retry support
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeWithRetry(
      () => dio.patch<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: _mergeOptions(options, headers: headers),
        cancelToken: cancelToken,
      ),
      'PATCH',
    );
  }

  /// DELETE request with retry support
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _executeWithRetry(
      () => dio.delete<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: _mergeOptions(options, headers: headers),
        cancelToken: cancelToken,
      ),
      'DELETE',
    );
  }

  /// Execute request with retry logic
  Future<Map<String, dynamic>> _executeWithRetry(
    Future<Response<Map<String, dynamic>>> Function() request,
    String method,
  ) async {
    int attempt = 0;
    while (true) {
      try {
        final response = await request();
        return _handleResponse(response);
      } on DioException catch (e) {
        // Don't retry on client errors (4xx) or cancellation
        if (e.response?.statusCode != null &&
                e.response!.statusCode! >= 400 &&
                e.response!.statusCode! < 500 ||
            e.type == DioExceptionType.cancel) {
          throw _handleDioException(e);
        }

        // Retry on network errors or server errors (5xx)
        attempt++;
        if (attempt > config.maxRetries) {
          throw _handleDioException(e);
        }

        // Wait before retry (exponential backoff)
        await Future.delayed(
          Duration(milliseconds: config.retryDelay.inMilliseconds * attempt),
        );
      } catch (e) {
        if (e is ApiException || e is DioException) {
          rethrow;
        }
        throw ApiException(
          message: '$method request failed: ${e.toString()}',
          statusCode: 0,
        );
      }
    }
  }

  /// Merge options with default headers
  Options _mergeOptions(Options? options, {Map<String, String>? headers}) {
    final mergedHeaders = headers != null
        ? {...defaultHeaders, ...headers}
        : defaultHeaders;

    return options != null
        ? options.copyWith(
            headers: mergedHeaders,
            validateStatus:
                options.validateStatus ??
                (status) => status != null && status < 500,
          )
        : Options(
            headers: mergedHeaders,
            validateStatus: (status) => status != null && status < 500,
          );
  }

  /// Handle API response
  Map<String, dynamic> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Handle successful status codes (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (responseData == null || responseData.isEmpty) {
        return {};
      }

      // Check for success field in response
      if (responseData.containsKey('success')) {
        final success = responseData['success'];
        if (success == false) {
          // API returned success: false, extract message
          final message =
              responseData['message'] as String? ?? 'Request failed';
          throw ApiException(
            message: message,
            statusCode: statusCode,
            data: responseData,
          );
        }
      }

      return responseData;
    }

    // Handle error status codes
    final errorMap = responseData;
    throw ApiException(
      message:
          errorMap?['message'] as String? ??
          errorMap?['error'] as String? ??
          'Request failed',
      statusCode: statusCode,
      data: errorMap,
    );
  }

  /// Set authentication token
  /// Best Practice: Automatically called when token is saved to AppPref
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    defaultHeaders['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  /// Best Practice: Called on logout to clear auth headers
  void removeAuthToken() {
    dio.options.headers.remove('Authorization');
    defaultHeaders.remove('Authorization');
  }

  /// Refresh authentication token from shared preferences
  /// Best Practice: Call this after updating token in AppPref
  void refreshAuthToken() {
    _loadAuthToken();
  }

  /// Add interceptor for logging, error handling, etc.
  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  /// Clear all interceptors
  void clearInterceptors() {
    dio.interceptors.clear();
  }

  /// Handle DioException and convert to ApiException
  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiTimeoutException(
          message: 'Connection timeout. Please try again.',
          timeout: 'connection',
        );
      case DioExceptionType.sendTimeout:
        return ApiTimeoutException(
          message: 'Send timeout. Please try again.',
          timeout: 'send',
        );
      case DioExceptionType.receiveTimeout:
        return ApiTimeoutException(
          message: 'Receive timeout. Please try again.',
          timeout: 'receive',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final errorData = error.response?.data;
        String message = 'Request failed';

        if (errorData is Map<String, dynamic>) {
          message =
              errorData['message'] as String? ??
              errorData['error'] as String? ??
              message;
        } else if (errorData is String) {
          message = errorData;
        }

        // Create specific exceptions based on status code
        if (statusCode == 401) {
          return ApiUnauthorizedException(
            message: message,
            data: errorData is Map ? errorData as Map<String, dynamic>? : null,
          );
        } else if (statusCode == 403) {
          return ApiForbiddenException(
            message: message,
            data: errorData is Map ? errorData as Map<String, dynamic>? : null,
          );
        } else if (statusCode == 404) {
          return ApiNotFoundException(
            message: message,
            data: errorData is Map ? errorData as Map<String, dynamic>? : null,
          );
        } else if (statusCode >= 500) {
          return ApiServerException(
            message: message,
            statusCode: statusCode,
            data: errorData is Map ? errorData as Map<String, dynamic>? : null,
          );
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          data: errorData is Map ? errorData as Map<String, dynamic>? : null,
        );
      case DioExceptionType.cancel:
        return ApiCancelledException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiNetworkException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badCertificate:
        return ApiCertificateException(
          message: 'Certificate error. Please check your connection.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: 0,
        );
    }
  }
}

/// Base API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({required this.message, required this.statusCode, this.data});

  @override
  String toString() => message;
}

/// Network connection exception
class ApiNetworkException extends ApiException {
  ApiNetworkException({required super.message}) : super(statusCode: 0);
}

/// Timeout exception
class ApiTimeoutException extends ApiException {
  final String timeout; // 'connection', 'send', 'receive'

  ApiTimeoutException({required super.message, required this.timeout})
    : super(statusCode: 0);
}

/// Unauthorized exception (401)
class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException({required super.message, super.data})
    : super(statusCode: 401);
}

/// Forbidden exception (403)
class ApiForbiddenException extends ApiException {
  ApiForbiddenException({required super.message, super.data})
    : super(statusCode: 403);
}

/// Not found exception (404)
class ApiNotFoundException extends ApiException {
  ApiNotFoundException({required super.message, super.data})
    : super(statusCode: 404);
}

/// Server exception (5xx)
class ApiServerException extends ApiException {
  ApiServerException({
    required super.message,
    required super.statusCode,
    super.data,
  });
}

/// Request cancelled exception
class ApiCancelledException extends ApiException {
  ApiCancelledException({required super.message}) : super(statusCode: 0);
}

/// Certificate exception
class ApiCertificateException extends ApiException {
  ApiCertificateException({required super.message}) : super(statusCode: 0);
}
