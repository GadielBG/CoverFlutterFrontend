import 'package:dio/dio.dart';
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
  final String baseUrl;
  
  // TODO: Cambiar por SharedPreferences o secure storage
  String? _token;
  User? _currentUser;

  AuthRepositoryImpl({
    required this.dio,
    this.baseUrl = 'http://localhost:3000/api', // Cambiar por tu URL real
  });

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/auth/login',
        data: {
          'correo': email,
          'contrasena': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'] as String;
        
        await saveToken(token);
        await saveUser(user);
        
        return {
          'user': user,
          'token': token,
        };
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión. Verifica tu internet');
      } else {
        throw Exception('Error al conectar con el servidor');
      }
    } catch (e) {
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
      final response = await dio.post(
        '$baseUrl/auth/register',
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'] as String;
        
        await saveToken(token);
        await saveUser(user);
        
        return {
          'user': user,
          'token': token,
        };
      } else {
        throw Exception('Error al registrar usuario');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('El usuario o correo ya existe');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Error de conexión. Verifica tu internet');
      } else {
        throw Exception('Error al conectar con el servidor');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    await clearAuthData();
  }

  @override
  Future<String?> getToken() async {
    // TODO: Implementar con SharedPreferences o secure storage
    return _token;
  }

  @override
  Future<User?> getCurrentUser() async {
    // TODO: Implementar con SharedPreferences o secure storage
    return _currentUser;
  }

  @override
  Future<void> saveToken(String token) async {
    // TODO: Implementar con SharedPreferences o secure storage
    _token = token;
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  Future<void> saveUser(User user) async {
    // TODO: Implementar con SharedPreferences o secure storage
    _currentUser = user;
  }

  @override
  Future<void> clearAuthData() async {
    // TODO: Implementar con SharedPreferences o secure storage
    _token = null;
    _currentUser = null;
    dio.options.headers.remove('Authorization');
  }
}