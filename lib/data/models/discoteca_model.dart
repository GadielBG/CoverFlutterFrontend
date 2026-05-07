class Discoteca {
  final int id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String? correoContacto;
  final String? tipo;
  final String? descripcion;
  final String? zonaBarrio;
  final String? ciudad;
  final String? referencia;
  final String? horarioApertura;
  final String? horarioCierre;
  final int? capacidadTotal;
  final String? precioMinimoMesa;
  final String? precioMesaVip;
  final double? ratingPromedio;
  final int? totalResenas;
  final String? logoUrl;
  final bool verificado;
  final bool estaActiva;
  final double? latitud;
  final double? longitud;

  Discoteca({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.correoContacto,
    this.tipo,
    this.descripcion,
    this.zonaBarrio,
    this.ciudad,
    this.referencia,
    this.horarioApertura,
    this.horarioCierre,
    this.capacidadTotal,
    this.precioMinimoMesa,
    this.precioMesaVip,
    this.ratingPromedio,
    this.totalResenas,
    this.logoUrl,
    this.verificado = false,
    required this.estaActiva,
    this.latitud,
    this.longitud,
  });

  factory Discoteca.desdeJson(Map<String, dynamic> json) {
    return Discoteca(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correoContacto: json['correo_contacto'],
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      zonaBarrio: json['zona_barrio'],
      ciudad: json['ciudad'],
      referencia: json['referencia'],
      horarioApertura: json['horario_apertura'],
      horarioCierre: json['horario_cierre'],
      capacidadTotal: json['capacidad_total'],
      precioMinimoMesa: json['precio_minimo_mesa']?.toString(),
      precioMesaVip: json['precio_mesa_vip']?.toString(),
      ratingPromedio: json['rating_promedio'] != null
          ? double.tryParse(json['rating_promedio'].toString())
          : null,
      totalResenas: json['total_resenas'],
      logoUrl: json['logo_url'],
      verificado: json['verificado'] ?? false,
      estaActiva: json['estado'] == 'activo',
      latitud: json['latitud'] != null
          ? double.tryParse(json['latitud'].toString())
          : null,
      longitud: json['longitud'] != null
          ? double.tryParse(json['longitud'].toString())
          : null,
    );
  }
}
