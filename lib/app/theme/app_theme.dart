import 'package:flutter/material.dart';

class AppTheme {
  // COLORCITOS
  static const Color backgroundColor = Color(0xFF1B1B1B);
  static const Color surfaceColor = Color(0xFF2A2A2A);
  static const Color primaryYellow = Color(0xFFD3FF00);
  static const Color primaryPink = Color(0xFFFF7BDA);
  static const Color textColor = Colors.white;
  static const Color hintColor = Color(0xFF888888);
  static const Color inputBorderColor = Color(0xFF6B46C1);
  static const Color errorColor = Color(0xFFFF4D6D);
  static const Color successColor = Color(0xFF4CAF50);

  // GRADIENTES
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

  // ESPACIADOS
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // BORDES REDONDEADOS
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 30.0;
  static const double radiusFull = 100.0;

  /* ----------------------------------------------------------------------------------------- */
  // ESTILOS DE TEXTO

  // Títulos principales
  static const TextStyle tituloPagina = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: textColor,
    letterSpacing: -0.5,
  );

  // Subtitulos bajo del título
  static TextStyle subtituloPagina = TextStyle(
    fontSize: 14,
    color: textColor.withOpacity(0.45),
  );

  // Logo COVER
  static const TextStyle estiloLogo = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: textColor,
    letterSpacing: 6,
  );

  // Etiquetas
  static TextStyle etiquetaSeccion = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: textColor.withOpacity(0.35),
    letterSpacing: 1.5,
  );

  // Texto de campos de formulario
  static const TextStyle textoCampo = TextStyle(
    color: textColor,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  // Sugerencia de campos
  static TextStyle textoHint = TextStyle(
    color: textColor.withOpacity(0.35),
    fontSize: 14,
  );

  // Texto de boton principal
  static const TextStyle textoBoton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textColor,
    letterSpacing: 0.3,
  );

  // Texto pequeño
  static TextStyle textoPequeno = TextStyle(
    color: textColor.withOpacity(0.45),
    fontSize: 14,
  );

  // LSink con gradientes
  static const TextStyle textoLink = TextStyle(
    color: textColor,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  // Texto de error
  static const TextStyle textoError = TextStyle(
    color: errorColor,
    fontSize: 11,
  );

  // DECORACIÓN DE INPUTS
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
      //fillColor: textColor.withOpacity(0.05),
      fillColor: Colors.black.withOpacity(0.4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(color: textColor.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(color: textColor.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: BorderSide(color: primaryPink.withOpacity(0.7), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMd),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      errorStyle: textoError,
    );
  }

  // DECORACIÓN DE CARDS
  static BoxDecoration cardDecoracion = BoxDecoration(
    color: Colors.black.withOpacity(0.1),
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: textColor.withOpacity(0.08)),
  );

  static BoxDecoration cardDestacadoDecoracion = BoxDecoration(
    gradient: cardGradient,
    borderRadius: BorderRadius.circular(radiusLg),
    border: Border.all(color: textColor.withOpacity(0.1)),
  );

  // DECORACIÓN DE BOTÓN PRIMARIO
  static BoxDecoration botonPrimaryDecoracion = BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.circular(radiusMd),
    boxShadow: [
      BoxShadow(
        color: primaryPink.withOpacity(0.35),
        blurRadius: 20,
        spreadRadius: 0,
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

  // DECORACIÓN BOTÓN SECUNDARIO
  static BoxDecoration botonSecundarioDecoracion = BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: textColor.withOpacity(0.2)),
  );

  // DECORACIÓN BOTÓN DE ATRÁS
  static BoxDecoration botonAtrasDecoracion = BoxDecoration(
    color: textColor.withOpacity(0.07),
    borderRadius: BorderRadius.circular(radiusSm + 4),
    border: Border.all(color: textColor.withOpacity(0.08)),
  );

  // SNACKBAR
  static SnackBar snackbarError(String mensaje) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: textColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: const TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      margin: const EdgeInsets.all(spacingMd),
    );
  }

  static SnackBar snackbarExito(String mensaje) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: textColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje, style: const TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      margin: const EdgeInsets.all(spacingMd),
    );
  }

  // THEME DATA
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
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: backgroundColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: textoBoton,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPink,
          textStyle: textoLink,
        ),
      ),
      iconTheme: const IconThemeData(color: textColor),
      dividerTheme: const DividerThemeData(color: hintColor, thickness: 0.5),
    );
  }
}
