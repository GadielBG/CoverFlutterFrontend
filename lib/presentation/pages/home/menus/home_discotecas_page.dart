import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../data/models/discoteca_model.dart';
import '../../../../data/repositories/discoteca_repository.dart';
import '../../../../injection_container.dart';
import '../../profile/profile_page.dart';
import '../discoteca_detail_page.dart';

class HomeDiscotecasPage extends StatefulWidget {
  const HomeDiscotecasPage({super.key});

  @override
  State<HomeDiscotecasPage> createState() => _HomeDiscotecasPageState();
}

class _HomeDiscotecasPageState extends State<HomeDiscotecasPage> {
  String _categoriaActual = 'Bares';
  late final DiscotecaRepository _repositorioDiscoteca;
  late Future<List<Discoteca>> _futuroDiscotecas;

  @override
  void initState() {
    super.initState();
    _repositorioDiscoteca = sl<DiscotecaRepository>();
    _futuroDiscotecas = _repositorioDiscoteca.obtenerDiscotecasActivas();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _construirCabecera(),
          _construirCategorias(),
          _construirSeccionPrincipal(),
          const SizedBox(height: AppTheme.spacingXl),
        ],
      ),
    );
  }

  Widget _construirCabecera() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingMd + 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, estado) {
                  String nombre = "Invitado";
                  if (estado is AuthAuthenticated) {
                    nombre = estado.user.nombreCompleto.split(' ')[0];
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Buenas noches,', style: AppTheme.textoSaludo),
                      Text('$nombre 👋', style: AppTheme.textoNombreUsuario),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.primaryYellow,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  _construirAvatar(),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: AppTheme.barraBusquedaDecoracion,
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppTheme.textColor.withOpacity(0.3),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Buscar locales...',
                        style: AppTheme.textoSearchHint,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _botonCircularAccion(Icons.tune),
            ],
          ),
        ],
      ),
    );
  }

  Widget _construirAvatar() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, estado) {
        String inicial = "U";
        if (estado is AuthAuthenticated)
          inicial = estado.user.nombreCompleto[0].toUpperCase();
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
          child: Container(
            width: 45,
            height: 45,
            decoration: AppTheme.botonPrimarioCircular,
            child: Center(
              child: Text(
                inicial,
                style: AppTheme.textoBoton.copyWith(
                  color: AppTheme.backgroundColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _botonCircularAccion(IconData icono) {
    return Container(
      width: 54,
      height: 54,
      decoration: AppTheme.botonCircularDecoracion,
      child: Icon(icono, color: AppTheme.textColor, size: 22),
    );
  }

  Widget _construirCategorias() {
    final listaCategorias = [
      {'nombre': 'Bares', 'icono': Icons.local_bar_rounded},
      {'nombre': 'Discos', 'icono': Icons.music_note_rounded},
      {'nombre': 'Pubs', 'icono': Icons.sports_bar_rounded},
      {'nombre': 'Karaoke', 'icono': Icons.mic_external_on_rounded},
      {'nombre': 'Lounge', 'icono': Icons.wine_bar_rounded},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: AppTheme.spacingMd),
        itemCount: listaCategorias.length,
        itemBuilder: (context, i) {
          final cat = listaCategorias[i];
          final esSeleccionada = _categoriaActual == cat['nombre'];
          return GestureDetector(
            onTap: () =>
                setState(() => _categoriaActual = cat['nombre'] as String),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: AppTheme.categoriaDecoracion(esSeleccionada),
                    child: Icon(
                      cat['icono'] as IconData,
                      color: esSeleccionada
                          ? AppTheme.primaryYellow
                          : AppTheme.textColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['nombre'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: esSeleccionada
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: esSeleccionada
                          ? AppTheme.primaryYellow
                          : AppTheme.textColor.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirSeccionPrincipal() {
    return FutureBuilder<List<Discoteca>>(
      future: _futuroDiscotecas,
      builder: (context, captura) {
        if (captura.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppTheme.primaryPink),
            ),
          );
        }

        if (captura.hasError || !captura.hasData || captura.data!.isEmpty) {
          return const Center(child: Text('No se encontraron locales activos'));
        }

        final datosRecibidos = captura.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _tarjetaDestacada(datosRecibidos.first),
              const SizedBox(height: AppTheme.spacingXl),
              Text('CERCA DE TI', style: AppTheme.etiquetaSeccion),
              const SizedBox(height: AppTheme.spacingMd),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: datosRecibidos.length > 1
                    ? datosRecibidos.length - 1
                    : 0,
                itemBuilder: (context, i) =>
                    _itemListaNormal(datosRecibidos[i + 1]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tarjetaDestacada(Discoteca d) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DiscotecaDetailPage(discoteca: d))),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardDestacadoDecoracion,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.whatshot,
                color: AppTheme.primaryYellow,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'DESTACADO',
                style: AppTheme.etiquetaSeccion.copyWith(
                  color: AppTheme.primaryYellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(d.nombre, style: AppTheme.tituloPagina.copyWith(fontSize: 24)),
          Text(
            'Zona ${d.zonaBarrio ?? "Central"} • ${d.tipo ?? "Bar"}',
            style: AppTheme.subtituloPagina.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.star, color: AppTheme.primaryYellow, size: 18),
              const Text(' 4.8', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                color: AppTheme.primaryPink.withOpacity(0.8),
                size: 18,
              ),
              const Text(' 350m', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _itemListaNormal(Discoteca d) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DiscotecaDetailPage(discoteca: d))),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoracion,
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: AppTheme.primaryPink,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.nombre,
                  style: AppTheme.textoCampo.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(d.tipo ?? 'Discoteca', style: AppTheme.textoPequeno),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppTheme.primaryYellow,
                      size: 16,
                    ),
                    const Text(' 4.5', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on,
                      color: AppTheme.primaryPink.withOpacity(0.6),
                      size: 16,
                    ),
                    Text(
                      ' 1.2km',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
