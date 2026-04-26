import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🌐 API_LOG: $obj'),
    ));
  }

  void actualizarToken(String? token) {
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      dio.options.headers.remove('Authorization');
    }
  }
}