import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fluttersampleachitecture/core/network/api_client.dart';
import 'package:fluttersampleachitecture/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:fluttersampleachitecture/features/auth/data/models/login_response.dart';

import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tLoginResponseJson = {
      'token': 'test_token',
      'userId': 'user123',
      'email': 'test@example.com',
      'refreshToken': 'refresh_token',
      'expiresIn': 3600,
    };
    final tLoginResponse = LoginResponse(
      token: 'test_token',
      userId: 'user123',
      email: 'test@example.com',
      refreshToken: 'refresh_token',
      expiresIn: 3600,
    );

    test(
      'should return LoginResponse when the call to api service is successful',
      () async {
        // arrange
        when(
          mockApiClient.post(
            '/login',
            body: {'email': tEmail, 'password': tPassword},
          ),
        ).thenAnswer((_) async => tLoginResponseJson);

        // act
        final result = await dataSource.login(tEmail, tPassword);

        // assert
        expect(result, isA<LoginResponse>());
        expect(result.token, tLoginResponse.token);
        expect(result.userId, tLoginResponse.userId);
        expect(result.email, tLoginResponse.email);
        expect(result.refreshToken, tLoginResponse.refreshToken);
        expect(result.expiresIn, tLoginResponse.expiresIn);

        // Verify that the API client was called with correct parameters
        verify(
          mockApiClient.post(
            '/login',
            body: {'email': tEmail, 'password': tPassword},
          ),
        ).called(1);
      },
    );

    test(
      'should return LoginResponse with minimal fields when optional fields are missing',
      () async {
        // arrange
        const minimalResponseJson = {
          'token': 'test_token',
          'email': 'test@example.com',
        };
        when(
          mockApiClient.post(
            '/login',
            body: {'email': tEmail, 'password': tPassword},
          ),
        ).thenAnswer((_) async => minimalResponseJson);

        // act
        final result = await dataSource.login(tEmail, tPassword);

        // assert
        expect(result, isA<LoginResponse>());
        expect(result.token, 'test_token');
        expect(result.email, 'test@example.com');
        expect(result.userId, '');
        expect(result.refreshToken, isNull);
        expect(result.expiresIn, isNull);
      },
    );

    test('should throw Exception when ApiException is thrown', () async {
      // arrange
      when(
        mockApiClient.post(
          '/login',
          body: {'email': tEmail, 'password': tPassword},
        ),
      ).thenThrow(
        ApiException(message: 'Invalid credentials', statusCode: 401),
      );

      // act
      final call = dataSource.login;

      // assert
      expect(() => call(tEmail, tPassword), throwsA(isA<Exception>()));
      expect(
        () => call(tEmail, tPassword),
        throwsA(predicate((e) => e.toString().contains('Invalid credentials'))),
      );
    });

    test(
      'should throw Exception with network error message when other exception occurs',
      () async {
        // arrange
        when(
          mockApiClient.post(
            '/login',
            body: {'email': tEmail, 'password': tPassword},
          ),
        ).thenThrow(Exception('Connection timeout'));

        // act
        final call = dataSource.login;

        // assert
        expect(() => call(tEmail, tPassword), throwsA(isA<Exception>()));
        expect(
          () => call(tEmail, tPassword),
          throwsA(predicate((e) => e.toString().contains('Network error'))),
        );
      },
    );

    test('should handle snake_case response keys', () async {
      // arrange
      const snakeCaseResponseJson = {
        'token': 'test_token',
        'user_id': 'user123',
        'email': 'test@example.com',
        'refresh_token': 'refresh_token',
        'expires_in': 3600,
      };
      when(
        mockApiClient.post(
          '/login',
          body: {'email': tEmail, 'password': tPassword},
        ),
      ).thenAnswer((_) async => snakeCaseResponseJson);

      // act
      final result = await dataSource.login(tEmail, tPassword);

      // assert
      expect(result.userId, 'user123');
      expect(result.refreshToken, 'refresh_token');
      expect(result.expiresIn, 3600);
    });
  });

  group('logout', () {
    test(
      'should complete successfully when logout call is successful',
      () async {
        // arrange
        when(
          mockApiClient.post(any),
        ).thenAnswer((_) async => <String, dynamic>{});

        final dataSource = AuthRemoteDataSourceImpl(mockApiClient);

        // act
        final result = dataSource.logout();

        // assert
        expect(result, completes);
        verify(mockApiClient.post('/logout')).called(1);
      },
    );

    test('should throw Exception when ApiException is thrown', () async {
      // arrange
      when(
        mockApiClient.post(any),
      ).thenThrow(ApiException(message: 'Unauthorized', statusCode: 401));

      final dataSource = AuthRemoteDataSourceImpl(mockApiClient);

      // act
      final call = dataSource.logout;

      // assert
      expect(() => call(), throwsA(isA<Exception>()));
      expect(
        () => call(),
        throwsA(predicate((e) => e.toString().contains('Unauthorized'))),
      );
    });

    test(
      'should throw Exception with network error message when other exception occurs',
      () async {
        // arrange
        when(mockApiClient.post(any)).thenThrow(Exception('Network error'));

        final dataSource = AuthRemoteDataSourceImpl(mockApiClient);

        // act
        final call = dataSource.logout;

        // assert
        expect(() => call(), throwsA(isA<Exception>()));
        expect(
          () => call(),
          throwsA(predicate((e) => e.toString().contains('Network error'))),
        );
      },
    );
  });
}
