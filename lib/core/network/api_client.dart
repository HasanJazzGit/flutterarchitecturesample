import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl;
  final Dio dio;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    Dio? dio,
    Map<String, String>? defaultHeaders,
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
           {'Content-Type': 'application/json', 'Accept': 'application/json'};

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
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.data == null || response.data!.isEmpty) {
        return {};
      }
      return response.data!;
    } else {
      final statusCode = response.statusCode ?? 0;
      final errorData = response.data;
      final errorMap = errorData is Map<String, dynamic> ? errorData : null;
      throw ApiException(
        message: errorMap?['message'] as String? ?? 'Request failed',
        statusCode: statusCode,
        data: errorMap,
      );
    }
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
    defaultHeaders['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    dio.options.headers.remove('Authorization');
    defaultHeaders.remove('Authorization');
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
