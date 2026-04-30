import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'menus/home_discotecas_page.dart';
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
    const Center(child: Text('Explorar')),
    const HomeDiscotecasPage(),
    const Center(child: Text('Calendario')),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(child: _paginas[_indiceSeleccionado]),
      bottomNavigationBar: _construirNavInferior(),
    );
  }

  Widget _construirNavInferior() {
    return Container(
      decoration: AppTheme.navBarDecoracion,
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
    );
  }

  Widget _itemNav(IconData icono, int indice) {
    final seleccionado = _indiceSeleccionado == indice;
    return GestureDetector(
      onTap: () => setState(() => _indiceSeleccionado = indice),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            color: seleccionado
                ? AppTheme.primaryYellow
                : AppTheme.textColor.withOpacity(0.3),
            size: 28,
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: seleccionado ? 4 : 0,
            decoration: const BoxDecoration(
              color: AppTheme.primaryYellow,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemNavCentral() {
    return GestureDetector(
      onTap: () => setState(() => _indiceSeleccionado = 2),
      child: Container(
        width: 60,
        height: 60,
        decoration: AppTheme.botonPrimarioCircular,
        child: const Icon(
          Icons.home_filled,
          color: AppTheme.backgroundColor,
          size: 32,
        ),
      ),
    );
  }
}
