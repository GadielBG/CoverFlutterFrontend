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
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: d.logoUrl != null
            ? Image.network(
                d.logoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fondoPlaceholder(),
              )
            : _fondoPlaceholder(),
        title: Text(
          d.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
          ),
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
          Row(
            children: [
              const Icon(Icons.location_on, color: AppTheme.primaryPink, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  d.direccion ?? 'Sin dirección',
                  style: AppTheme.textoPequeno,
                ),
              ),
            ],
          ),
          if (d.zonaBarrio != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.map_outlined, color: AppTheme.primaryYellow, size: 18),
                const SizedBox(width: 6),
                Text('Zona ${d.zonaBarrio}', style: AppTheme.textoPequeno),
              ],
            ),
          ],
          if (d.tipo != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryYellow.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryYellow.withOpacity(0.3)),
              ),
              child: Text(
                d.tipo!,
                style: const TextStyle(
                  color: AppTheme.primaryYellow,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (d.precioMinimoMesa != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money, color: AppTheme.primaryPink, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Precio mínimo mesa: Bs ${d.precioMinimoMesa}',
                  style: AppTheme.textoPequeno,
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          const Divider(color: Colors.white12),
        ],
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
                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Sin eventos próximos',
                      style: AppTheme.textoPequeno,
                    ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
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
                            fontSize: 12,
                            color: AppTheme.primaryYellow,
                          ),
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
                        color: AppTheme.primaryPink.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
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
}
