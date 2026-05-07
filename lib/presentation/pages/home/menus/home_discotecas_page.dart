import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _categoriaActual = 'Todos';
  late Future<List<Discoteca>> _futuroDiscotecas;

  static const _mapaTipos = {
    'Bares': ['bar', 'bar de copas', 'cocktail bar'],
    'Discos': ['discoteca', 'disco', 'club', 'club nocturno'],
    'Pubs': ['pub'],
    'Karaoke': ['karaoke'],
    'Lounge': ['lounge', 'lounge bar'],
  };

  List<Discoteca> _filtrar(List<Discoteca> todos) {
    if (_categoriaActual == 'Todos') return todos;
    final tiposValidos = _mapaTipos[_categoriaActual] ?? [];
    return todos
        .where((d) =>
            d.tipo != null &&
            tiposValidos.contains(d.tipo!.toLowerCase().trim()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _futuroDiscotecas = sl<DiscotecaRepository>().obtenerDiscotecasActivas();
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
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _construirCabecera() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                      Text('Buenas noches,', style: AppTheme.textoSaludo),
                      Text('$nombre 👋',
                          style: AppTheme.textoNombreUsuario),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  _botonIcono(Icons.notifications_none_rounded),
                  const SizedBox(width: 10),
                  _construirAvatar(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _construirBusqueda(),
        ],
      ),
    );
  }

  Widget _construirBusqueda() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: AppTheme.barraBusquedaDecoracion,
            child: Row(
              children: [
                Icon(Icons.search,
                    color: Colors.white.withValues(alpha: 0.25), size: 20),
                const SizedBox(width: 10),
                Text('Buscar locales...', style: AppTheme.textoSearchHint),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _botonIcono(Icons.tune_rounded),
      ],
    );
  }

  Widget _construirAvatar() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, estado) {
        String inicial = "U";
        if (estado is AuthAuthenticated) {
          inicial = estado.user.nombreCompleto[0].toUpperCase();
        }
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                backgroundColor: AppTheme.backgroundColor,
                body: const ProfilePage(),
              ),
            ),
          ),
          child: Container(
            width: 42,
            height: 42,
            decoration: AppTheme.botonPrimarioCircular,
            child: Center(
              child: Text(
                inicial,
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _botonIcono(IconData icono) {
    return Container(
      width: 46,
      height: 46,
      decoration: AppTheme.botonCircularDecoracion,
      child: Icon(icono, color: Colors.white.withValues(alpha: 0.7), size: 20),
    );
  }

  Widget _construirCategorias() {
    final categorias = [
      {'nombre': 'Todos', 'icono': Icons.apps_rounded},
      {'nombre': 'Bares', 'icono': Icons.local_bar_rounded},
      {'nombre': 'Discos', 'icono': Icons.music_note_rounded},
      {'nombre': 'Pubs', 'icono': Icons.sports_bar_rounded},
      {'nombre': 'Karaoke', 'icono': Icons.mic_external_on_rounded},
      {'nombre': 'Lounge', 'icono': Icons.wine_bar_rounded},
    ];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: categorias.length,
        itemBuilder: (context, i) {
          final cat = categorias[i];
          final sel = _categoriaActual == cat['nombre'];
          return GestureDetector(
            onTap: () =>
                setState(() => _categoriaActual = cat['nombre'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: sel ? AppTheme.buttonGradient : null,
                color: sel ? null : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                border: Border.all(
                  color: sel
                      ? Colors.transparent
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icono'] as IconData,
                    size: 14,
                    color: sel ? Colors.black : Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat['nombre'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      color: sel ? Colors.black : Colors.white.withValues(alpha: 0.5),
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
          return const Padding(
            padding: EdgeInsets.all(60),
            child:
                Center(child: CircularProgressIndicator(color: AppTheme.primaryPink)),
          );
        }
        if (captura.hasError ||
            !captura.hasData ||
            captura.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
                child: Text('No hay locales disponibles',
                    style: AppTheme.textoPequeno)),
          );
        }

        final datos = _filtrar(captura.data!);

        if (datos.isEmpty) return _estadoVacioFiltro();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              _tarjetaDestacada(datos.first),
              if (datos.length > 1) ...[
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('CERCA DE TI', style: AppTheme.etiquetaSeccion),
                    Text(
                      'Ver todos',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primaryYellow,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: datos.length - 1,
                  itemBuilder: (context, i) => _itemListaNormal(datos[i + 1]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _estadoVacioFiltro() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Icon(Icons.search_off_rounded,
                color: Colors.white.withValues(alpha: 0.25), size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin locales en esta categoría',
            style: AppTheme.textoCampo
                .copyWith(color: Colors.white.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 6),
          Text(
            'Pronto habrá más locales disponibles',
            style: AppTheme.textoPequeno,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _tarjetaDestacada(Discoteca d) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DiscotecaDetailPage(discoteca: d))),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen o fondo degradado
            d.logoUrl != null
                ? Image.network(d.logoUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fondoPurpura())
                : _fondoPurpura(),

            // Overlay degradado
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),

            // Contenido
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryYellow.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                            border: Border.all(
                                color: AppTheme.primaryYellow
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.whatshot,
                                  color: AppTheme.primaryYellow, size: 12),
                              const SizedBox(width: 4),
                              Text('DESTACADO',
                                  style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primaryYellow,
                                      letterSpacing: 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(d.nombre,
                        style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 13,
                            color: Colors.white.withValues(alpha: 0.6)),
                        const SizedBox(width: 3),
                        Text(
                          '${d.zonaBarrio ?? "Centro"} · ${d.tipo ?? "Bar"}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.6)),
                        ),
                        const Spacer(),
                        const Icon(Icons.star,
                            color: AppTheme.primaryYellow, size: 14),
                        Text(' 4.8',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fondoPurpura() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D1066), Color(0xFF6B0F4A)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.nightlife_rounded,
            color: Colors.white24, size: 80),
      ),
    );
  }

  Widget _itemListaNormal(Discoteca d) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DiscotecaDetailPage(discoteca: d))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: AppTheme.cardDecoracion,
        child: Row(
          children: [
            // Logo
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3D1066), Color(0xFF6B0F4A)],
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: d.logoUrl != null
                  ? Image.network(d.logoUrl!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.music_note_rounded,
                          color: Colors.white38,
                          size: 28))
                  : const Icon(Icons.music_note_rounded,
                      color: Colors.white38, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.nombre,
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(
                    '${d.tipo ?? "Local"} · ${d.zonaBarrio ?? "La Paz"}',
                    style: AppTheme.textoPequeno,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: AppTheme.primaryYellow, size: 13),
                      Text(' 4.5',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7))),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on,
                          color: AppTheme.primaryPink.withValues(alpha: 0.7),
                          size: 13),
                      Text(' 1.2km',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4))),
                      if (d.precioMinimoMesa != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPink.withValues(alpha: 0.12),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Text(
                            'Bs ${d.precioMinimoMesa}+',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.primaryPink,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.2), size: 20),
          ],
        ),
      ),
    );
  }
}
