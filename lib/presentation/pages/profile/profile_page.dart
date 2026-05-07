import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../../app/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, estado) {
        if (estado is AuthAuthenticated) {
          final usuario = estado.user;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10),
                _construirCabecera(context),
                const SizedBox(height: 30),
                _construirAvatar(usuario.nombreCompleto),
                const SizedBox(height: 20),
                Text(
                  usuario.nombreCompleto,
                  style: AppTheme.tituloPagina.copyWith(fontSize: 24),
                ),
                Text(usuario.correo, style: AppTheme.subtituloPagina),
                const SizedBox(height: 30),
                _construirCajaEstadisticas(),
                const SizedBox(height: 30),
                _construirSeccionTitulo('PRÓXIMAS RESERVAS'),
                _construirTarjetaReserva(
                  fecha: '15',
                  mes: 'MAR',
                  lugar: 'La Costilla Bar',
                  detalle: 'Mesa 4 · 21:00 · 4 personas',
                  estado: 'Confirmada',
                  colorEstado: Colors.greenAccent,
                ),
                _construirTarjetaReserva(
                  fecha: '22',
                  mes: 'MAR',
                  lugar: 'Forum Club',
                  detalle: 'VIP · 23:00 · 6 personas',
                  estado: 'Pendiente',
                  colorEstado: Colors.orangeAccent,
                ),
                const SizedBox(height: 20),
                _construirSeccionTitulo('HISTORIAL'),
                _construirTarjetaReserva(
                  fecha: '08',
                  mes: 'MAR',
                  lugar: 'Diesel Lounge',
                  detalle: 'Mesa 2 · 22:00 · 2 personas',
                  estado: 'Completada',
                  colorEstado: Colors.grey,
                ),
                _construirTarjetaReserva(
                  fecha: '01',
                  mes: 'MAR',
                  lugar: 'Malegría Bar',
                  detalle: 'Mesa 7 · 20:30 · 3 personas',
                  estado: 'Completada',
                  colorEstado: Colors.grey,
                ),
                const SizedBox(height: 20),
                _construirOpcionMenu(
                  icono: Icons.credit_card,
                  titulo: 'Métodos de Pago',
                  colorIcono: AppTheme.primaryPink,
                  alTocar: () {},
                ),
                _construirOpcionMenu(
                  icono: Icons.favorite,
                  titulo: 'Locales Favoritos',
                  colorIcono: AppTheme.primaryPink,
                  alTocar: () {},
                ),
                _construirOpcionMenu(
                  icono: Icons.confirmation_number,
                  titulo: 'Mis Cupones',
                  colorIcono: AppTheme.primaryPink,
                  alTocar: () {},
                ),
                _construirOpcionMenu(
                  icono: Icons.exit_to_app,
                  titulo: 'Cerrar Sesión',
                  colorIcono: Colors.redAccent,
                  esSalida: true,
                  alTocar: () => _mostrarConfirmacionSalida(context),
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        }
        return const Center(
          child: Text(
            'No hay usuario autenticado',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _construirCabecera(BuildContext contexto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Mi Perfil', style: AppTheme.tituloPagina),
        Container(
          decoration: AppTheme.botonCircularDecoracion,
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppTheme.textColor,
              size: 22,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _construirAvatar(String nombre) {
    final iniciales = nombre
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: AppTheme.botonPrimarioCircular,
          child: Center(
            child: Text(
              iniciales,
              style: const TextStyle(
                color: AppTheme.backgroundColor,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2A2A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _construirCajaEstadisticas() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: AppTheme.cardDecoracion,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemEstadistica('12', 'Reservas'),
          _itemEstadistica('8', 'Locales'),
          _itemEstadistica('4.8', 'Rating', esRating: true),
        ],
      ),
    );
  }

  Widget _itemEstadistica(
    String valor,
    String etiqueta, {
    bool esRating = false,
  }) {
    return Column(
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: esRating ? AppTheme.primaryPink : Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(etiqueta, style: AppTheme.textoPequeno.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _construirSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(titulo, style: AppTheme.etiquetaSeccion),
      ),
    );
  }

  Widget _construirTarjetaReserva({
    required String fecha,
    required String mes,
    required String lugar,
    required String detalle,
    required String estado,
    required Color colorEstado,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: AppTheme.cardDecoracion,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  fecha,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  mes,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lugar,
                      style: AppTheme.textoCampo.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorEstado.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        estado,
                        style: TextStyle(
                          color: colorEstado,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  detalle,
                  style: AppTheme.textoPequeno.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirOpcionMenu({
    required IconData icono,
    required String titulo,
    required Color colorIcono,
    required VoidCallback alTocar,
    bool esSalida = false,
  }) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withValues(alpha:0.05)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorIcono.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icono, color: colorIcono, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                titulo,
                style: AppTheme.textoCampo.copyWith(
                  color: esSalida ? Colors.redAccent : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  void _mostrarConfirmacionSalida(BuildContext contexto) {
    showDialog(
      context: contexto,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Cerrar sesión',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          '¿Estás seguro de que quieres salir?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              contexto.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
