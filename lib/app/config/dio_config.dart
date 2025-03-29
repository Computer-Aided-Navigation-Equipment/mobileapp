import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_cane_app/AppConstants.dart';

class DioConfig {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://192.168.0.104:6001/api", // Use 10.0.2.2 for localhost in Android emulator
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Dio get instance {
    _dio.interceptors.clear(); // Ensure no duplicate interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _storage.read(key: 'accessToken');

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print("this case");
        if (error.response?.statusCode == 401) {
          print("Token expired");
          RequestOptions originalRequest = error.requestOptions;

          if (originalRequest.extra['retry'] == true) {
            return handler.reject(error);
          }

          originalRequest.extra['retry'] = true;

          try {
            final refreshResponse = await _dio.post('/user/refresh-token');
            final newAccessToken = refreshResponse.data['accessToken'];

            await _storage.write(key: 'accessToken', value: newAccessToken);

            originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await _dio.fetch(originalRequest);
            return handler.resolve(response);
          } catch (refreshError) {
            await _storage.delete(key: 'accessToken');
            await _storage.delete(key: 'refreshToken');

            // Redirect to login screen (handle accordingly in Flutter)
            // Example: Get.offAllNamed('/login');
          }
        }

        return handler.reject(error);
      },
    ));

    return _dio;
  }
}
