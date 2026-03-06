import 'package:dio/dio.dart';
import 'package:food_app/core/utils/pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://sonic-zdi0.onrender.com/api',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: Duration(seconds: 15),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 300;
      },
    ),
  );

  DioClient() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final String? token = PrefHelper.getToken();
      if (token != null && token.isNotEmpty && token != 'guest') {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    }));
  }

  Dio get dio => _dio;
}
