part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String nombreUsuario;
  final String correo;
  final String contrasena;
  final String nombreCompleto;
  final String? telefono;
  final String? carnet;
  final String? fechaNacimiento;

  const RegisterEvent({
    required this.nombreUsuario,
    required this.correo,
    required this.contrasena,
    required this.nombreCompleto,
    this.telefono,
    this.carnet,
    this.fechaNacimiento
  });

  @override
  List<Object?> get props => [
        nombreUsuario,
        correo,
        contrasena,
        nombreCompleto,
        telefono,
        carnet,
        fechaNacimiento,
      ];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}