import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String nombreUsuario,
    required String correo,
    required String contrasena,
    required String nombreCompleto,
    String? telefono,
    String? carnet,
  });

  Future<void> logout();
  Future<String?> getToken();
  Future<User?> getCurrentUser();
  Future<void> saveToken(String token);
  Future<void> saveUser(User user);
  Future<void> clearAuthData();
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final SharedPreferences sharedPreferences;
  final String baseUrl;

  // Keys para SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthRepositoryImpl({
    required this.dio,
    required this.sharedPreferences,
    // 🔥 CAMBIAR ESTA URL SEGÚN TU CASO:

    // Para EMULADOR Android:
    //this.baseUrl = 'http://10.0.2.2:3030/persona',

    // Para DISPOSITIVO FÍSICO (cambiar por tu IP):
    this.baseUrl = 'http://192.168.10.22:3030/persona',

    // Para iOS Simulator:
    // this.baseUrl = 'http://localhost:3000/api',
  }) {
    // 🔥 AGREGAR LOGS PARA DEBUG
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('🌐 DIO: $obj'),
      ),
    );
    
    // Configurar el token si existe
    _configureAuthHeader();
  }
  
  Future<void> _configureAuthHeader() async {
    final token = await getToken();
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🚀 Intentando login...');
      print('📍 URL: $baseUrl/loginCLiente');

      final response = await dio.post(
        '$baseUrl/loginCliente',
        data: {'correo': email, 'contrasena': password},
      );

      print('✅ Login response: ${response.statusCode}');
      print('📄 Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['persona']);
        final token = data['token'] as String;

        await saveToken(token);
        await saveUser(user);

        return {'user': user, 'token': token};
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      print('❌ Login Error: ${e.type}');
      print('📄 Response: ${e.response?.data}');
      print('🔢 Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión. Verifica tu internet');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'No se puede conectar al servidor. Verifica la URL: $baseUrl',
        );
      } else {
        throw Exception('Error del servidor: ${e.response?.data ?? e.message}');
      }
    } catch (e) {
      print('❌ Error inesperado: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String nombreUsuario,
    required String correo,
    required String contrasena,
    required String nombreCompleto,
    String? telefono,
    String? carnet,
  }) async {
    try {
      print('🚀 Intentando registrar usuario...');
      print('📍 URL: $baseUrl/registerCliente');
      print('👤 Usuario: $nombreUsuario');
      print('📧 Email: $correo');

      final response = await dio.post(
        '$baseUrl/registerCliente',
        data: {
          'nombre_usuario': nombreUsuario,
          'correo': correo,
          'contrasena': contrasena,
          'nombre_completo': nombreCompleto,
          'telefono': telefono,
          'carnet': carnet,
          'rol': 'cliente',
          'estado': 'activo',
        },
      );

      print('✅ Register response: ${response.statusCode}');
      print('📄 Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['persona']);
        final token = data['token'] as String;

        await saveToken(token);
        await saveUser(user);

        return {'user': user, 'token': token};
      } else {
        throw Exception('Error al registrar usuario');
      }
    } on DioException catch (e) {
      print('❌ Register Error: ${e.type}');
      print('📄 Response: ${e.response?.data}');
      print('🔢 Status: ${e.response?.statusCode}');
      print('💬 Message: ${e.message}');

      if (e.response?.statusCode == 409) {
        throw Exception('El usuario o correo ya existe');
      } else if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data['message'] ?? 'Datos inválidos';
        throw Exception('Error de validación: $errorMsg');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión. El servidor no responde');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'No se puede conectar al servidor. Verifica la URL: $baseUrl',
        );
      } else {
        final errorMsg =
            e.response?.data['message'] ?? e.message ?? 'Error desconocido';
        throw Exception('Error del servidor: $errorMsg');
      }
    } catch (e) {
      print('❌ Error inesperado en register: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    await clearAuthData();
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson != null) {
      try {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('❌ Error al decodificar usuario: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<void> saveUser(User user) async {
    final userModel = user as UserModel;
    final userJson = json.encode(userModel.toJson());
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userKey);
    dio.options.headers.remove('Authorization');
  }
}