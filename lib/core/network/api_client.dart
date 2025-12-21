import 'package:dio/dio.dart';
import '../di/dependency_injection.dart';
import '../storage/app_pref.dart';
import 'api_logger_interceptor.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  final Map<String, String> defaultHeaders;
  final bool enableLogging;

  ApiClient({
    required this.baseUrl,
    Dio? dio,
    Map<String, String>? defaultHeaders,
    this.enableLogging = true,
  }) : dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: baseUrl,
               headers:
                   defaultHeaders ??
                   {
                     'Content-Type': 'application/json',
                     'Accept': 'application/json',
                   },
               connectTimeout: const Duration(seconds: 30),
               receiveTimeout: const Duration(seconds: 30),
             ),
           ),
       defaultHeaders =
           defaultHeaders ??
           {'Content-Type': 'application/json', 'Accept': 'application/json'} {
    // Add logger interceptor if logging is enabled
    if (enableLogging) {
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

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers != null ? {...defaultHeaders, ...headers} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'GET request failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: Options(
          headers: headers != null ? {...defaultHeaders, ...headers} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'POST request failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: Options(
          headers: headers != null ? {...defaultHeaders, ...headers} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'PUT request failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<Map<String, dynamic>>(
        endpoint,
        data: data,
        options: Options(
          headers: headers != null ? {...defaultHeaders, ...headers} : null,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: 'DELETE request failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  Map<String, dynamic> _handleResponse(
    Response<Map<String, dynamic>> response,
  ) {
    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;

    // Handle successful status codes (200, 201)
    if (statusCode == 200 || statusCode == 201) {
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

    // Handle other status codes
    final errorMap = responseData;
    throw ApiException(
      message: errorMap?['message'] as String? ?? 'Request failed',
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

  ApiException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please try again.',
          statusCode: 0,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final errorData = error.response?.data;
        String message = 'Request failed';

        if (errorData is Map<String, dynamic>) {
          message = errorData['message'] as String? ?? message;
        } else if (errorData is String) {
          message = errorData;
        }

        return ApiException(
          message: message,
          statusCode: statusCode,
          data: errorData is Map ? errorData as Map<String, dynamic>? : null,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled', statusCode: 0);
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );
      case DioExceptionType.badCertificate:
        return ApiException(message: 'Certificate error', statusCode: 0);
      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? 'Unknown error occurred',
          statusCode: 0,
        );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({required this.message, required this.statusCode, this.data});

  @override
  String toString() => message;
}
