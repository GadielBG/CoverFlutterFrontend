import '../entities/user.dart';

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
    String? fechaNacimiento,
  });

  Future<void> logout();
  Future<String?> getToken();
  Future<User?> getCurrentUser();
  Future<void> saveToken(String token);
  Future<void> saveUser(User user);
  Future<void> clearAuthData();
}