import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../../app/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header con botón de volver
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Text(
                              'Mi Perfil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Botón de editar
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryYellow),
                            onPressed: () {
                              // TODO: Navegar a editar perfil
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Avatar y nombre
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: AppTheme.buttonGradient,
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPink.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user.nombreCompleto.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.backgroundColor,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Nombre completo
                    Text(
                      user.nombreCompleto,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Username
                    Text(
                      '@${user.nombreUsuario}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Estado
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: user.isActivo ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: user.isActivo ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        user.isActivo ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          color: user.isActivo ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Información del perfil
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildInfoSection(
                            'Información Personal',
                            [
                              _buildInfoTile(Icons.email_outlined, 'Correo Electrónico', user.correo),
                              if (user.telefono != null && user.telefono!.isNotEmpty)
                                _buildInfoTile(Icons.phone_outlined, 'Teléfono', user.telefono!),
                              if (user.carnet != null && user.carnet!.isNotEmpty)
                                _buildInfoTile(Icons.badge_outlined, 'Carnet', user.carnet!),
                              _buildInfoTile(Icons.person_outline, 'Rol', user.rol.toUpperCase()),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          _buildInfoSection(
                            'Información de la Cuenta',
                            [
                              if (user.creadoEn != null)
                                _buildInfoTile(
                                  Icons.calendar_today_outlined,
                                  'Miembro desde',
                                  _formatDate(user.creadoEn!),
                                ),
                              if (user.actualizadoEn != null)
                                _buildInfoTile(
                                  Icons.update_outlined,
                                  'Última actualización',
                                  _formatDate(user.actualizadoEn!),
                                ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Botón de cerrar sesión
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade600, Colors.red.shade800],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppTheme.surfaceColor,
                                    title: const Text(
                                      '¿Cerrar sesión?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: const Text(
                                      '¿Estás seguro de que deseas cerrar sesión?',
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
                                          context.read<AuthBloc>().add(LogoutEvent());
                                          Navigator.of(context).popUntil((route) => route.isFirst);
                                        },
                                        child: const Text(
                                          'Cerrar sesión',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              icon: const Icon(Icons.logout, color: Colors.white),
                              label: const Text(
                                'Cerrar Sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
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
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.inputBorderColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.primaryYellow,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryPink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryPink, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}