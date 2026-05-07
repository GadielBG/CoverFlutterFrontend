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

  Widget _campoTexto({
    required TextEditingController controller,
    required String hint,
    required IconData icono,
    TextInputType teclado = TextInputType.text,
    bool readOnly = false,
    bool obscure = false,
    Widget? sufijo,
    int? maxLength,
    String? counterText,
    TextCapitalization capitalization = TextCapitalization.none,
    VoidCallback? alTocar,
    String? Function(String?)? validador,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: teclado,
      readOnly: readOnly,
      obscureText: obscure,
      maxLength: maxLength,
      textCapitalization: capitalization,
      style: AppTheme.textoCampo,
      decoration: AppTheme.inputDecoracion(
        hint: hint,
        icono: icono,
        sufijo: sufijo,
        counterText: counterText,
      ),
      onTap: alTocar,
      validator: validador,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(AppTheme.snackbarError(state.message));
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm + 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: AppTheme.botonAtrasDecoracion,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppTheme.textColor,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingMd),
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.buttonGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: Text('COVER', style: AppTheme.estiloLogo),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd + 4,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppTheme.spacingMd),
                          Text(
                            'Crear cuenta',
                            style: AppTheme.tituloPagina,
                          ),
                          const SizedBox(height: AppTheme.spacingXs),

                          Text(
                            'Completa tus datos para registrarte',
                            style: AppTheme.subtituloPagina,
                          ),
                          const SizedBox(height: AppTheme.spacingXl - 4),

                          Text(
                            'Información personal',
                            style: AppTheme.etiquetaSeccion,
                          ),
                          const SizedBox(height: AppTheme.spacingSm + 4),

                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingMd),
                            decoration: AppTheme.cardDecoracion,
                            child: Column(
                              children: [
                                _campoTexto(
                                  controller: _nombreCompletoController,
                                  hint: 'Nombre completo',
                                  icono: Icons.person_outline,
                                  validador: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Por favor ingrese su nombre completo';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                _campoTexto(
                                  controller: _nombreUsuarioController,
                                  hint: 'Nombre de usuario',
                                  icono: Icons.alternate_email,
                                  validador: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Por favor ingrese un nombre de usuario';
                                    if (value.length < 3)
                                      return 'Mínimo 3 caracteres';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                _campoTexto(
                                  controller: _correoController,
                                  hint: 'Correo electrónico',
                                  icono: Icons.email_outlined,
                                  teclado: TextInputType.emailAddress,
                                  validador: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Por favor ingrese su correo';
                                    if (!value.contains('@'))
                                      return 'Ingrese un correo válido';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _campoTexto(
                                        controller: _carnetController,
                                        hint: 'Carnet de identidad',
                                        icono: Icons.badge_outlined,
                                        teclado: TextInputType.number,
                                        validador: (valor) {
                                          if (valor == null || valor.isEmpty)
                                            return 'Por favor ingrese su carnet de identidad';
                                          if (!RegExp(r'^\d+$').hasMatch(valor))
                                            return 'Por favor ingrese solo números';
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppTheme.spacingSm + 2,
                                    ),
                                    SizedBox(
                                      width: 95,
                                      child: _campoTexto(
                                        controller: _complementoController,
                                        hint: 'Comp.',
                                        icono: Icons.add_circle_outline,
                                        maxLength: 2,
                                        counterText: '',
                                        capitalization:
                                            TextCapitalization.characters,
                                        validador: (valor) {
                                          if (valor != null &&
                                              valor.isNotEmpty) {
                                            if (!RegExp(
                                              r'^[A-Za-z0-9]{2}$',
                                            ).hasMatch(valor))
                                              return 'Ej: 1A';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                _campoTexto(
                                  controller: _fechaNacimientoController,
                                  hint: 'Fecha de nacimiento',
                                  icono: Icons.calendar_today_outlined,
                                  readOnly: true,
                                  alTocar: _seleccionarFecha,
                                  validador: (valor) {
                                    if (valor == null || valor.isEmpty)
                                      return 'Por favor seleccione su fecha de nacimiento';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                _campoTexto(
                                  controller: _telefonoController,
                                  hint: 'Teléfono (opcional)',
                                  icono: Icons.phone_outlined,
                                  teclado: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingLg),

                          Text('Seguridad', style: AppTheme.etiquetaSeccion),
                          const SizedBox(height: AppTheme.spacingSm + 4),

                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingMd),
                            decoration: AppTheme.cardDecoracion,
                            child: Column(
                              children: [
                                _campoTexto(
                                  controller: _contrasenaController,
                                  hint: 'Contraseña',
                                  icono: Icons.lock_outline,
                                  obscure: _obscurePassword,
                                  sufijo: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.hintColor,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                  validador: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Por favor ingrese una contraseña';
                                    if (value.length < 5)
                                      return 'Mínimo 5 caracteres';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppTheme.spacingMd),
                                _campoTexto(
                                  controller: _confirmarContrasenaController,
                                  hint: 'Confirmar contraseña',
                                  icono: Icons.lock_outline,
                                  obscure: _obscureConfirmPassword,
                                  sufijo: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppTheme.hintColor,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirmPassword =
                                          !_obscureConfirmPassword,
                                    ),
                                  ),
                                  validador: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Por favor confirme su contraseña';
                                    if (value != _contrasenaController.text)
                                      return 'Las contraseñas no coinciden';
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppTheme.spacingXl),

                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: state is AuthLoading ? null : _register,
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: state is AuthLoading
                                      ? AppTheme.botonPrimaryDeshabilitadoDecoracion
                                      : AppTheme.botonPrimaryDecoracion,
                                  child: Center(
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppTheme.textColor,
                                            ),
                                          )
                                        : Text(
                                            'Crear cuenta',
                                            style: AppTheme.textoBoton,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingLg),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¿Ya tienes una cuenta? ',
                                  style: AppTheme.textoPequeno,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => AppTheme
                                        .buttonGradient
                                        .createShader(bounds),
                                    child: Text(
                                      'Iniciar sesión',
                                      style: AppTheme.textoLink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXl),
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
