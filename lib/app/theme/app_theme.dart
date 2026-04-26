import 'package:flutter/material.dart';

class AppTheme {
  // --- COLORES ---
  static const Color backgroundColor = Color(0xFF1B1B1B);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  static const Color primaryYellow = Color(0xFFD3FF00);
  static const Color primaryPink = Color(0xFFFF7BDA);
  static const Color textColor = Colors.white;
  static const Color hintColor = Color(0xFF888888);
  static const Color inputBorderColor = Color(0xFF6B46C1);
  static const Color errorColor = Color(0xFFFF4D6D);
  static const Color successColor = Color(0xFF4CAF50);

  static const double opacidadBorde = 0.08;
  static const double opacidadFondoInput = 0.4;
  static const double opacidadFondoCard = 0.1;

  // --- GRADIENTES ---
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primaryYellow, primaryPink],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      backgroundColor,
      Color(0xFF2A1A3E),
      Color(0xFF1A1A2E),
      backgroundColor,
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A1A3E), Color(0xFF1A1A2E)],
  );

  // --- ESPACIADOS Y RADIOS ---
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 30.0;
  static const double radiusFull = 100.0;

  // --- ESTILOS DE TEXTO ---
  static const TextStyle tituloPagina = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: textColor,
    letterSpacing: -0.5,
  );

  static TextStyle subtituloPagina = TextStyle(
    fontSize: 14,
    color: textColor.withOpacity(0.45),
  );

  static const TextStyle estiloLogo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: textColor,
    letterSpacing: 6,
  );

  static TextStyle etiquetaSeccion = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: textColor.withOpacity(0.35),
    letterSpacing: 1.5,
  );

  static const TextStyle textoCampo = TextStyle(color: textColor, fontSize: 15);

  static const TextStyle textoBoton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textColor,
  );

  static TextStyle textoPequeno = TextStyle(
    color: textColor.withOpacity(0.45),
    fontSize: 14,
  );

  static const TextStyle textoLink = TextStyle(
    color: textColor,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const TextStyle textoNombreUsuario = TextStyle(
    fontSize: 28,
    color: textColor,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle textoSaludo = TextStyle(
    fontSize: 16,
    color: textColor,
    fontWeight: FontWeight.w300,
  );

  static TextStyle textoSearchHint = TextStyle(
    color: textColor.withOpacity(0.3),
    fontSize: 14,
  );

  static const TextStyle textoUbicacion = TextStyle(
    color: textColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // --- DECORACIONES DE COMPONENTES ---

  static InputDecoration inputDecoracion({
    required String hint,
    required IconData icono,
    Widget? sufijo,
    String? counterText,
  }) {
    return InputDecoration(
      hintText: hint,
      counterText: counterText,
      hintStyle: TextStyle(color: textColor.withOpacity(0.35), fontSize: 14),
      prefixIcon: Icon(icono, color: textColor.withOpacity(0.4), size: 20),
      suffixIcon: sufijo,
      filled: true,
      fillColor: Colors.black.withOpacity(opacidadFondoInput),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: _crearBorde(),
      enabledBorder: _crearBorde(),
      focusedBorder: _crearBorde(
        color: primaryPink.withOpacity(0.7),
        ancho: 1.5,
      ),
      errorBorder: _crearBorde(color: errorColor),
      focusedErrorBorder: _crearBorde(color: errorColor, ancho: 1.5),
      errorStyle: const TextStyle(color: errorColor, fontSize: 11),
    );
  }

  static OutlineInputBorder _crearBorde({Color? color, double ancho = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(
        color: color ?? textColor.withOpacity(opacidadBorde),
        width: ancho,
      ),
    );
  }

  static BoxDecoration cardDecoracion = BoxDecoration(
    color: Colors.black.withOpacity(opacidadFondoCard),
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: textColor.withOpacity(opacidadBorde)),
  );

  static BoxDecoration cardDestacadoDecoracion = BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A148C), Color(0xFF880E4F)],
    ),
    borderRadius: BorderRadius.circular(radiusLg),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration categoriaDecoracion(bool esSeleccionado) {
    return BoxDecoration(
      color: esSeleccionado
          ? Colors.transparent
          : Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: esSeleccionado ? primaryYellow : textColor.withOpacity(0.1),
        width: 1.5,
      ),
    );
  }

  static BoxDecoration botonPrimaryDecoracion = BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: [
      BoxShadow(
        color: primaryPink.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration botonPrimaryDeshabilitadoDecoracion = BoxDecoration(
    gradient: LinearGradient(
      colors: [primaryPink.withOpacity(0.4), primaryPink.withOpacity(0.4)],
    ),
    borderRadius: BorderRadius.circular(radiusMd),
  );

  static BoxDecoration botonAtrasDecoracion = BoxDecoration(
    color: textColor.withOpacity(0.07),
    borderRadius: BorderRadius.circular(radiusSm + 4),
    border: Border.all(color: textColor.withOpacity(opacidadBorde)),
  );

  static BoxDecoration botonPrimarioCircular = BoxDecoration(
    gradient: buttonGradient,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: primaryPink.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration barraBusquedaDecoracion = BoxDecoration(
    color: Colors.black.withOpacity(opacidadFondoInput),
    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
    border: Border.all(color: textColor.withOpacity(opacidadBorde)),
  );

  static BoxDecoration navBarDecoracion = BoxDecoration(
    color: const Color(0xFF131313),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 20,
        offset: const Offset(0, -5),
      ),
    ],
  );

  static BoxDecoration botonCircularDecoracion = BoxDecoration(
    color: textColor.withOpacity(0.07),
    shape: BoxShape.circle,
    border: Border.all(color: textColor.withOpacity(opacidadBorde)),
  );

  // --- SNACKBARS ---
  static SnackBar snackbarError(String mensaje) =>
      _generarSnackBar(mensaje, errorColor, Icons.error_outline);

  static SnackBar snackbarExito(String mensaje) =>
      _generarSnackBar(mensaje, successColor, Icons.check_circle_outline);

  static SnackBar _generarSnackBar(
    String mensaje,
    Color fondo,
    IconData icono,
  ) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icono, color: textColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: const TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: fondo,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      margin: const EdgeInsets.all(spacingMd),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryYellow,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryYellow,
        secondary: primaryPink,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
    );
  }
}
