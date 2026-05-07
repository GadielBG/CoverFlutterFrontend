import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'menus/home_discotecas_page.dart';
import 'menus/explorar_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceSeleccionado = 2;

  final List<Widget> _paginas = [
    const Center(child: Text('Notificaciones')),
    const ExplorarPage(),
    const HomeDiscotecasPage(),
    const Center(child: Text('Calendario')),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBody: true,
      body: _paginas[_indiceSeleccionado],
      bottomNavigationBar: _construirNavInferior(),
    );
  }

  Widget _construirNavInferior() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            border: Border(
              top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.07), width: 1),
            ),
          ),
          child: SafeArea(
            child: SizedBox(
              height: 68,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _itemNav(Icons.notifications_none_rounded, 0),
                  _itemNav(Icons.explore_outlined, 1),
                  _itemNavCentral(),
                  _itemNav(Icons.calendar_month_outlined, 3),
                  _itemNav(Icons.person_outline_rounded, 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemNav(IconData icono, int indice) {
    final seleccionado = _indiceSeleccionado == indice;
    return GestureDetector(
      onTap: () => setState(() => _indiceSeleccionado = indice),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              color: seleccionado
                  ? AppTheme.primaryYellow
                  : Colors.white.withValues(alpha: 0.28),
              size: 26,
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: seleccionado ? 20 : 0,
              decoration: BoxDecoration(
                gradient: seleccionado ? AppTheme.buttonGradient : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemNavCentral() {
    final seleccionado = _indiceSeleccionado == 2;
    return GestureDetector(
      onTap: () => setState(() => _indiceSeleccionado = 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: seleccionado
            ? AppTheme.botonPrimarioCircular
            : BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12)),
              ),
        child: Icon(
          Icons.home_filled,
          color: seleccionado ? Colors.black : Colors.white.withValues(alpha: 0.4),
          size: 28,
        ),
      ),
    );
  }
}
