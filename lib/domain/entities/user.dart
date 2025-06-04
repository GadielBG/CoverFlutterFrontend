import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String nombreUsuario;
  final String correo;
  final String nombreCompleto;
  final String? telefono;
  final String? carnet;
  final String rol;
  final String estado;
  final DateTime? creadoEn;
  final DateTime? actualizadoEn;

  const User({
    required this.id,
    required this.nombreUsuario,
    required this.correo,
    required this.nombreCompleto,
    this.telefono,
    this.carnet,
    required this.rol,
    required this.estado,
    this.creadoEn,
    this.actualizadoEn,
  });

  @override
  List<Object?> get props => [
        id,
        nombreUsuario,
        correo,
        nombreCompleto,
        telefono,
        carnet,
        rol,
        estado,
        creadoEn,
        actualizadoEn,
      ];

  // Método para verificar si es cliente
  bool get isCliente => rol == 'cliente';

  // Método para verificar si está activo
  bool get isActivo => estado == 'activo';
}