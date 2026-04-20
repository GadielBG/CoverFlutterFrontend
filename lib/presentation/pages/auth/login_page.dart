import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../../app/theme/app_theme.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
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
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.spacingXl),

                    Center(
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.buttonGradient.createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                        child: const Text(
                          'COVER',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textColor,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacingXxl),
                    const Text('Iniciar sesión', style: AppTheme.tituloPagina),
                    const SizedBox(height: AppTheme.spacingXs),

                    Text(
                      'Ingresa tus credenciales para continuar',
                      style: AppTheme.subtituloPagina,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),

                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: AppTheme.cardDecoracion,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: AppTheme.textoCampo,
                            decoration: AppTheme.inputDecoracion(
                              hint: 'Correo electrónico',
                              icono: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Por favor ingrese su correo';
                              if (!value.contains('@'))
                                return 'Ingrese un correo válido';
                              return null;
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: AppTheme.textoCampo,
                            decoration: AppTheme.inputDecoracion(
                              hint: 'Contraseña',
                              icono: Icons.lock_outline,
                              sufijo: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.hintColor,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Por favor ingrese su contraseña';
                              if (value.length < 5)
                                return 'Mínimo 5 caracteres';
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
                          onTap: state is AuthLoading ? null : _login,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
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
                                  : const Text(
                                      'Iniciar sesión',
                                      style: AppTheme.textoBoton,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppTheme.spacingXl),

                    Center(
                      child: Text(
                        'Ingresa también con',
                        style: AppTheme.textoPequeno,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _botonSocial(Icons.facebook, const Color(0xFF1877F2)),
                        const SizedBox(width: AppTheme.spacingMd - 1),
                        _botonSocial(
                          Icons.g_mobiledata,
                          const Color(0xFFDB4437),
                        ),
                        const SizedBox(width: AppTheme.spacingMd - 1),
                        _botonSocial(Icons.apple, AppTheme.textColor),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingXl),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes una cuenta? ',
                            style: AppTheme.textoPequeno,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) =>
                                  AppTheme.buttonGradient.createShader(bounds),
                              child: const Text(
                                'Regístrate aquí',
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
        ),
      ),
    );
  }

  Widget _botonSocial(IconData icono, Color color) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.textColor.withOpacity(0.08)),
      ),
      child: IconButton(
        icon: Icon(icono, color: color, size: 24),
        onPressed: () {},
      ),
    );
  }
}
