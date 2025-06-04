import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.nombreUsuario,
    required super.correo,
    required super.nombreCompleto,
    super.telefono,
    super.carnet,
    required super.rol,
    required super.estado,
    super.creadoEn,
    super.actualizadoEn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombreUsuario: json['nombre_usuario'],
      correo: json['correo'],
      nombreCompleto: json['nombre_completo'],
      telefono: json['telefono'],
      carnet: json['carnet'],
      rol: json['rol'] ?? 'cliente',
      estado: json['estado'] ?? 'activo',
      creadoEn: json['creado_en'] != null 
          ? DateTime.parse(json['creado_en']) 
          : null,
      actualizadoEn: json['actualizado_en'] != null 
          ? DateTime.parse(json['actualizado_en']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre_usuario': nombreUsuario,
      'correo': correo,
      'nombre_completo': nombreCompleto,
      'telefono': telefono,
      'carnet': carnet,
      'rol': rol,
      'estado': estado,
      'creado_en': creadoEn?.toIso8601String(),
      'actualizado_en': actualizadoEn?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? nombreUsuario,
    String? correo,
    String? nombreCompleto,
    String? telefono,
    String? carnet,
    String? rol,
    String? estado,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      correo: correo ?? this.correo,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      telefono: telefono ?? this.telefono,
      carnet: carnet ?? this.carnet,
      rol: rol ?? this.rol,
      estado: estado ?? this.estado,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }
}