import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../../app/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreUsuarioController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarContrasenaController = TextEditingController();
  final _nombreCompletoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _carnetController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _complementoController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _fechaSeleccionada;

  @override
  void dispose() {
    _nombreUsuarioController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarContrasenaController.dispose();
    _nombreCompletoController.dispose();
    _telefonoController.dispose();
    _carnetController.dispose();
    _fechaNacimientoController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          nombreUsuario: _nombreUsuarioController.text.trim(),
          correo: _correoController.text.trim(),
          contrasena: _contrasenaController.text,
          nombreCompleto: _nombreCompletoController.text.trim(),
          telefono: _telefonoController.text.trim().isEmpty
              ? null
              : _telefonoController.text.trim(),
          fechaNacimiento: _fechaSeleccionada != null
              ? '${_fechaSeleccionada!.year}-'
                '${_fechaSeleccionada!.month.toString().padLeft(2, '0')}-'
                '${_fechaSeleccionada!.day.toString().padLeft(2, '0')}'
              : null,
          carnet: _carnetController.text.trim().isEmpty
              ? null
              : _complementoController.text.trim().isEmpty
              ? _carnetController.text.trim()
              : '${_carnetController.text.trim()}-${_complementoController.text.trim().toUpperCase()}',
        ),
      );
    }
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fechaElegida = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, hijo) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryPink,
              surface: Color(0xFF2A1A3E),
            ),
          ),
          child: hijo!,
        );
      },
    );

    if (fechaElegida != null) {
      setState(() {
        _fechaSeleccionada = fechaElegida;
        _fechaNacimientoController.text =
            '${fechaElegida.day.toString().padLeft(2, '0')}-'
            '${fechaElegida.month.toString().padLeft(2, '0')}-'
            '${fechaElegida.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Container(
          // 🔥 MISMO FONDO CON GRADIENTE
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.backgroundColor,
                Color(0xFF2A1A3E),
                Color(0xFF1A1A2E),
                AppTheme.backgroundColor,
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar personalizada
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      // 🔥 LOGO COVER CON GRADIENTE
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.buttonGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: const Text(
                          'COVER',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido scrollable
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const Text(
                            'Regístrate Aquí',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Contenedor con fondo semi-transparente
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Nombre de usuario
                                TextFormField(
                                  controller: _nombreUsuarioController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Nombre de usuario',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: AppTheme.hintColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese un nombre de usuario';
                                    }
                                    if (value.length < 3) {
                                      return 'El nombre de usuario debe tener al menos 3 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Nombre completo
                                TextFormField(
                                  controller: _nombreCompletoController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Nombre completo',
                                    prefixIcon: Icon(
                                      Icons.badge_outlined,
                                      color: AppTheme.hintColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su nombre completo';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Correo
                                TextFormField(
                                  controller: _correoController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Correo electrónico',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AppTheme.hintColor,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese su correo';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Por favor ingrese un correo válido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        controller: _carnetController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Carnet de identidad',
                                          prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.hintColor),
                                        ),
                                        validator: (valor) {
                                          if (valor == null || valor.isEmpty) {
                                            return 'Por favor ingrese su carnet es obligatorio';
                                          }
                                          if (!RegExp(r'^\d+$').hasMatch(valor)) {
                                            return 'Por favor ingrese solo números';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 90,
                                      child: TextFormField(
                                        controller: _complementoController,
                                        style: const TextStyle(color: Colors.white),
                                        textCapitalization: TextCapitalization.characters,
                                        maxLength: 2,
                                        decoration: const InputDecoration(
                                          hintText: 'Comp. (Opcional)',
                                          counterText: '',
                                          prefixIcon: Icon(Icons.add_circle_outline, color: AppTheme.hintColor),
                                        ),
                                        validator: (valor) {
                                          if (valor != null && valor.isNotEmpty) {
                                            if (!RegExp(r'^[A-Za-z0-9]{2}$').hasMatch(valor)) {
                                              return 'Ej: 1A';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _fechaNacimientoController,
                                  readOnly: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      hintText: 'Fecha de nacimiento',
                                      prefixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          color: AppTheme.hintColor)
                                  ),
                                  onTap: () => _seleccionarFecha(),
                                  validator: (valor) {
                                    if (valor == null || valor.isEmpty) {
                                      return 'Por favor ingrese su fecha de nacimiento';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Teléfono (opcional)
                                TextFormField(
                                  controller: _telefonoController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Teléfono (opcional)',
                                    prefixIcon: Icon(
                                      Icons.phone_outlined,
                                      color: AppTheme.hintColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Contraseña
                                TextFormField(
                                  controller: _contrasenaController,
                                  obscureText: _obscurePassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Contraseña',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppTheme.hintColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppTheme.hintColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese una contraseña';
                                    }
                                    if (value.length < 5) {
                                      return 'La contraseña debe tener al menos 5 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Confirmar contraseña
                                TextFormField(
                                  controller: _confirmarContrasenaController,
                                  obscureText: _obscureConfirmPassword,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Confirmar contraseña',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: AppTheme.hintColor,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppTheme.hintColor,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor confirme su contraseña';
                                    }
                                    if (value != _contrasenaController.text) {
                                      return 'Las contraseñas no coinciden';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 30),

                                // Botón de registro con gradiente
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.buttonGradient,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryPink
                                                .withOpacity(0.3),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : _register,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        child: state is AuthLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppTheme
                                                          .backgroundColor,
                                                    ),
                                              )
                                            : const Text(
                                                'Registrarse',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppTheme.backgroundColor,
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Link para login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '¿Ya tienes una cuenta? ',
                                style: TextStyle(
                                  color: AppTheme.hintColor,
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => AppTheme
                                      .buttonGradient
                                      .createShader(bounds),
                                  child: const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
