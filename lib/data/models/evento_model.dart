class Evento {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? tipoEvento;
  final String? imagenUrl;
  final String? fechaInicio;
  final String? fechaFin;
  final double? precioEntrada;
  final String estado;

  Evento({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.tipoEvento,
    this.imagenUrl,
    this.fechaInicio,
    this.fechaFin,
    this.precioEntrada,
    required this.estado,
  });

  factory Evento.desdeJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      tipoEvento: json['tipo_evento'],
      imagenUrl: json['imagen_url'],
      fechaInicio: json['fecha_inicio'],
      fechaFin: json['fecha_fin'],
      precioEntrada: json['precio_entrada'] != null
          ? double.tryParse(json['precio_entrada'].toString())
          : null,
      estado: json['estado'] ?? 'activo',
    );
  }
}
