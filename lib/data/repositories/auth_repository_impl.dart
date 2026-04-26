import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final respuesta = await apiClient.dio.post(
        '${ApiConstants.personaPath}/loginCliente',
        data: {'correo': email, 'contrasena': password},
      );

      if (respuesta.statusCode == 200) {
        final datos = respuesta.data;
        final usuario = UserModel.fromJson(datos['persona']);
        final token = datos['token'] as String;

        await saveToken(token);
        await saveUser(usuario);
        apiClient.actualizarToken(token);

        return {'user': usuario, 'token': token};
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      throw _procesarErrorDio(e);
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
    String? fechaNacimiento,
  }) async {
    try {
      final respuesta = await apiClient.dio.post(
        '${ApiConstants.personaPath}/registerCliente',
        data: {
          'nombre_usuario': nombreUsuario,
          'correo': correo,
          'contrasena': contrasena,
          'nombre_completo': nombreCompleto,
          'telefono': telefono,
          'carnet': carnet,
          'fecha_nacimiento': fechaNacimiento,
        },
      );

      if (respuesta.statusCode == 201 || respuesta.statusCode == 200) {
        final datos = respuesta.data;
        final usuario = UserModel.fromJson(datos['persona']);
        final token = datos['token'] as String;

        await saveToken(token);
        await saveUser(usuario);
        apiClient.actualizarToken(token);

        return {'user': usuario, 'token': token};
      } else {
        throw Exception('Error al registrar usuario');
      }
    } on DioException catch (e) {
      throw _procesarErrorDio(e);
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
    return sharedPreferences.getString(ApiConstants.tokenKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final usuarioJson = sharedPreferences.getString(ApiConstants.userKey);
    if (usuarioJson != null) {
      final usuarioMap = json.decode(usuarioJson) as Map<String, dynamic>;
      return UserModel.fromJson(usuarioMap);
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(ApiConstants.tokenKey, token);
  }

  @override
  Future<void> saveUser(User user) async {
    final usuarioModel = user as UserModel;
    final usuarioJson = json.encode(usuarioModel.toJson());
    await sharedPreferences.setString(ApiConstants.userKey, usuarioJson);
  }

  @override
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(ApiConstants.tokenKey);
    await sharedPreferences.remove(ApiConstants.userKey);
    apiClient.actualizarToken(null);
  }

  Exception _procesarErrorDio(DioException e) {
    if (e.response?.statusCode == 401) {
      return Exception('Credenciales incorrectas');
    } else if (e.response?.statusCode == 409) {
      return Exception('El usuario o correo ya existe');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('El servidor no responde');
    } else {
      final mensaje = e.response?.data['message'];
      if (mensaje is List) return Exception(mensaje.join(', '));
      return Exception(mensaje ?? 'Error de conexión con el servidor');
    }
  }
}
