class Discoteca {
  final int id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String? tipo;
  final String? zonaBarrio;
  final String? precioMinimoMesa;
  final String? logoUrl;
  final bool estaActiva;

  Discoteca({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.tipo,
    this.zonaBarrio,
    this.precioMinimoMesa,
    this.logoUrl,
    required this.estaActiva,
  });

  factory Discoteca.desdeJson(Map<String, dynamic> json) {
    return Discoteca(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      tipo: json['tipo'],
      zonaBarrio: json['zona_barrio'],
      precioMinimoMesa: json['precio_minimo_mesa'],
      logoUrl: json['logo_url'],
      estaActiva: json['estado'] == 'activo',
    );
  }
}
