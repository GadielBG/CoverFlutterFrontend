import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../data/models/discoteca_model.dart';
import '../../../data/models/evento_model.dart';
import '../../../data/repositories/discoteca_repository.dart';
import '../../../injection_container.dart';

class DiscotecaDetailPage extends StatefulWidget {
  final Discoteca discoteca;

  const DiscotecaDetailPage({super.key, required this.discoteca});

  @override
  State<DiscotecaDetailPage> createState() => _DiscotecaDetailPageState();
}

class _DiscotecaDetailPageState extends State<DiscotecaDetailPage> {
  late Future<List<Evento>> _futuroEventos;

  @override
  void initState() {
    super.initState();
    _futuroEventos =
        sl<DiscotecaRepository>().obtenerEventosPorDiscoteca(widget.discoteca.id);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.discoteca;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _construirAppBar(d),
          SliverToBoxAdapter(child: _construirInfo(d)),
          SliverToBoxAdapter(child: _construirSeccionEventos()),
        ],
      ),
    );
  }

  Widget _construirAppBar(Discoteca d) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: AppTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            d.logoUrl != null
                ? Image.network(d.logoUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fondoPlaceholder())
                : _fondoPlaceholder(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha:0.7)],
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(d.nombre,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
            if (d.verificado)
              const Icon(Icons.verified, color: AppTheme.primaryYellow, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _fondoPlaceholder() {
    return Container(
      decoration: AppTheme.cardDestacadoDecoracion,
      child: const Center(
        child: Icon(Icons.music_note_rounded, color: AppTheme.primaryPink, size: 60),
      ),
    );
  }

  Widget _construirInfo(Discoteca d) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tipo + Rating
          Row(
            children: [
              if (d.tipo != null)
                _chip(d.tipo!, AppTheme.primaryYellow),
              if (d.verificado) ...[
                const SizedBox(width: 8),
                _chip('Verificado', AppTheme.primaryPink),
              ],
              const Spacer(),
              if (d.ratingPromedio != null && d.ratingPromedio! > 0) ...[
                const Icon(Icons.star, color: AppTheme.primaryYellow, size: 16),
                const SizedBox(width: 4),
                Text(
                  d.ratingPromedio!.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                if (d.totalResenas != null)
                  Text(' (${d.totalResenas})',
                      style: TextStyle(color: Colors.white.withValues(alpha:0.5), fontSize: 12)),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // Descripción
          if (d.descripcion != null && d.descripcion!.isNotEmpty) ...[
            Text(d.descripcion!, style: AppTheme.textoPequeno.copyWith(height: 1.5)),
            const SizedBox(height: 16),
          ],

          // Info en grid
          _filaInfo(Icons.location_on, AppTheme.primaryPink,
              d.direccion ?? 'Sin dirección'),
          if (d.zonaBarrio != null)
            _filaInfo(Icons.map_outlined, AppTheme.primaryYellow,
                'Zona ${d.zonaBarrio}${d.ciudad != null ? ' · ${d.ciudad}' : ''}'),
          if (d.referencia != null)
            _filaInfo(Icons.signpost_outlined, Colors.white54, d.referencia!),
          if (d.telefono != null)
            _filaInfo(Icons.phone_outlined, AppTheme.primaryYellow, d.telefono!),
          if (d.correoContacto != null)
            _filaInfo(Icons.email_outlined, AppTheme.primaryPink, d.correoContacto!),

          // Horario
          if (d.horarioApertura != null || d.horarioCierre != null) ...[
            const SizedBox(height: 4),
            _filaInfo(
              Icons.access_time,
              AppTheme.primaryYellow,
              '${d.horarioApertura ?? '?'} – ${d.horarioCierre ?? '?'}',
            ),
          ],

          const SizedBox(height: 16),

          // Capacidad y precios
          Row(
            children: [
              if (d.capacidadTotal != null)
                _tarjetaDato('Capacidad', '${d.capacidadTotal} personas',
                    Icons.people_outline),
              if (d.capacidadTotal != null && d.precioMinimoMesa != null)
                const SizedBox(width: 12),
              if (d.precioMinimoMesa != null)
                _tarjetaDato('Mesa mínima', 'Bs ${_formatPrecio(d.precioMinimoMesa!)}',
                    Icons.table_restaurant_outlined),
            ],
          ),
          if (d.precioMesaVip != null) ...[
            const SizedBox(height: 12),
            _tarjetaDato('Mesa VIP', 'Bs ${_formatPrecio(d.precioMesaVip!)}',
                Icons.star_outline),
          ],

          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
        ],
      ),
    );
  }

  Widget _filaInfo(IconData icono, Color color, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(texto, style: AppTheme.textoPequeno)),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _tarjetaDato(String titulo, String valor, IconData icono) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Icon(icono, color: AppTheme.primaryYellow, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  Text(valor,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirSeccionEventos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event, color: AppTheme.primaryYellow, size: 20),
              const SizedBox(width: 8),
              Text('EVENTOS', style: AppTheme.etiquetaSeccion),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Evento>>(
            future: _futuroEventos,
            builder: (context, captura) {
              if (captura.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: AppTheme.primaryPink),
                  ),
                );
              }
              if (captura.hasError ||
                  !captura.hasData ||
                  captura.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text('Sin eventos próximos',
                        style: TextStyle(color: Colors.white54)),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: captura.data!.length,
                itemBuilder: (context, i) => _tarjetaEvento(captura.data![i]),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _tarjetaEvento(Evento evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.cardDecoracion,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppTheme.radiusMd),
              bottomLeft: Radius.circular(AppTheme.radiusMd),
            ),
            child: evento.imagenUrl != null
                ? Image.network(
                    evento.imagenUrl!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagenEventoPlaceholder(),
                  )
                : _imagenEventoPlaceholder(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evento.nombre,
                    style: AppTheme.textoCampo.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  if (evento.tipoEvento != null) ...[
                    const SizedBox(height: 4),
                    Text(evento.tipoEvento!, style: AppTheme.textoPequeno),
                  ],
                  if (evento.fechaInicio != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 12, color: AppTheme.primaryYellow),
                        const SizedBox(width: 4),
                        Text(
                          _formatearFecha(evento.fechaInicio!),
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.primaryYellow),
                        ),
                      ],
                    ),
                  ],
                  if (evento.precioEntrada != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Bs ${evento.precioEntrada!.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryPink.withValues(alpha:0.9),
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagenEventoPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.black26,
      child: const Icon(Icons.event, color: AppTheme.primaryPink, size: 32),
    );
  }

  String _formatearFecha(String fechaIso) {
    try {
      final dt = DateTime.parse(fechaIso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return fechaIso;
    }
  }

  String _formatPrecio(String precio) {
    final val = double.tryParse(precio);
    if (val == null) return precio;
    return val == val.truncateToDouble()
        ? val.toInt().toString()
        : val.toStringAsFixed(2);
  }
}
