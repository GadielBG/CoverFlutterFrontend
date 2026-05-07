import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../data/models/discoteca_model.dart';
import '../../../../data/repositories/discoteca_repository.dart';
import '../../../../injection_container.dart';
import '../discoteca_detail_page.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({super.key});

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  late Future<List<Discoteca>> _futuroDiscotecas;
  final MapController _mapController = MapController();

  // Centro de La Paz, Bolivia
  static const LatLng _centroPaz = LatLng(-16.5000, -68.1500);

  @override
  void initState() {
    super.initState();
    _futuroDiscotecas = sl<DiscotecaRepository>().obtenerDiscotecasActivas();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 12),
          child: Row(
            children: [
              Text('Explorar', style: AppTheme.tituloPagina),
              const Spacer(),
              const Icon(Icons.explore, color: AppTheme.primaryYellow, size: 24),
            ],
          ),
        ),
        _construirMapa(),
        Expanded(child: _construirListaDiscotecas()),
      ],
    );
  }

  Widget _construirMapa() {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: Colors.white12),
      ),
      clipBehavior: Clip.hardEdge,
      child: FutureBuilder<List<Discoteca>>(
        future: _futuroDiscotecas,
        builder: (context, captura) {
          final marcadores = _construirMarcadores(captura.data ?? []);
          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _centroPaz,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cover.app',
              ),
              if (marcadores.isNotEmpty) MarkerLayer(markers: marcadores),
            ],
          );
        },
      ),
    );
  }

  List<Marker> _construirMarcadores(List<Discoteca> discotecas) {
    // Posiciones aproximadas en La Paz para demo
    // (el backend no tiene lat/lng por ahora)
    final posiciones = [
      const LatLng(-16.4955, -68.1336),
      const LatLng(-16.5010, -68.1195),
      const LatLng(-16.5080, -68.1270),
      const LatLng(-16.5100, -68.1400),
      const LatLng(-16.4890, -68.1450),
    ];

    return List.generate(discotecas.length, (i) {
      final pos = posiciones[i % posiciones.length];
      return Marker(
        point: pos,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _abrirDetalle(discotecas[i]),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryPink,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPink.withValues(alpha:0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.music_note, color: Colors.white, size: 18),
          ),
        ),
      );
    });
  }

  Widget _construirListaDiscotecas() {
    return FutureBuilder<List<Discoteca>>(
      future: _futuroDiscotecas,
      builder: (context, captura) {
        if (captura.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryPink),
          );
        }
        if (captura.hasError || !captura.hasData || captura.data!.isEmpty) {
          return Center(
            child: Text('No hay locales disponibles', style: AppTheme.textoPequeno),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          itemCount: captura.data!.length,
          itemBuilder: (context, i) => _itemDiscoteca(captura.data![i]),
        );
      },
    );
  }

  Widget _itemDiscoteca(Discoteca d) {
    return GestureDetector(
      onTap: () => _abrirDetalle(d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: AppTheme.cardDecoracion,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryPink.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
              child: d.logoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Image.network(d.logoUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.music_note_rounded,
                              color: AppTheme.primaryPink)),
                    )
                  : const Icon(Icons.music_note_rounded,
                      color: AppTheme.primaryPink),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.nombre,
                    style: AppTheme.textoCampo
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${d.tipo ?? "Local"} • ${d.zonaBarrio ?? "La Paz"}',
                    style: AppTheme.textoPequeno,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  void _abrirDetalle(Discoteca d) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DiscotecaDetailPage(discoteca: d)),
    );
  }
}
