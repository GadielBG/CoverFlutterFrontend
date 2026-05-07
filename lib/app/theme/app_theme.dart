import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- COLORES ---
  static const Color backgroundColor = Color(0xFF0D0D0D);
  static const Color surfaceColor = Color(0xFF1A1A1A);
  static const Color cardColor = Color(0xFF141414);
  static const Color primaryYellow = Color(0xFFD3FF00);
  static const Color primaryPink = Color(0xFFFF7BDA);
  static const Color textColor = Colors.white;
  static const Color hintColor = Color(0xFF666666);
  static const Color inputBorderColor = Color(0xFF333333);
  static const Color errorColor = Color(0xFFFF4D6D);
  static const Color successColor = Color(0xFF4CAF50);

  static const double opacidadBorde = 0.1;
  static const double opacidadFondoInput = 0.3;
  static const double opacidadFondoCard = 0.06;

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
      Color(0xFF0D0D0D),
      Color(0xFF1A0D2E),
      Color(0xFF0D1A2E),
      Color(0xFF0D0D0D),
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1030), Color(0xFF0D1520)],
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
  static const double radiusXl = 28.0;
  static const double radiusFull = 100.0;

  // --- TIPOGRAFÍA (Outfit + Inter) ---
  static TextStyle get tituloPagina => GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.5,
      );

  static TextStyle get subtituloPagina => GoogleFonts.inter(
        fontSize: 14,
        color: textColor.withValues(alpha: 0.45),
      );

  static TextStyle get estiloLogo => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 8,
      );

  static TextStyle get etiquetaSeccion => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: textColor.withValues(alpha: 0.35),
        letterSpacing: 1.8,
      );

  static TextStyle get textoCampo => GoogleFonts.inter(
        color: textColor,
        fontSize: 15,
      );

  static TextStyle get textoBoton => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textColor,
      );

  static TextStyle get textoPequeno => GoogleFonts.inter(
        color: textColor.withValues(alpha: 0.45),
        fontSize: 13,
      );

  static TextStyle get textoLink => GoogleFonts.inter(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

  static TextStyle get textoNombreUsuario => GoogleFonts.outfit(
        fontSize: 26,
        color: textColor,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get textoSaludo => GoogleFonts.inter(
        fontSize: 14,
        color: textColor.withValues(alpha: 0.5),
        fontWeight: FontWeight.w400,
      );

  static TextStyle get textoSearchHint => GoogleFonts.inter(
        color: textColor.withValues(alpha: 0.3),
        fontSize: 14,
      );

  static TextStyle get textoUbicacion => GoogleFonts.inter(
        color: textColor,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  // --- DECORACIONES ---
  static InputDecoration inputDecoracion({
    required String hint,
    required IconData icono,
    Widget? sufijo,
    String? counterText,
  }) {
    return InputDecoration(
      hintText: hint,
      counterText: counterText,
      hintStyle: GoogleFonts.inter(
          color: textColor.withValues(alpha: 0.3), fontSize: 14),
      prefixIcon:
          Icon(icono, color: textColor.withValues(alpha: 0.35), size: 20),
      suffixIcon: sufijo,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: _crearBorde(),
      enabledBorder: _crearBorde(),
      focusedBorder: _crearBorde(
        color: primaryPink.withValues(alpha: 0.6),
        ancho: 1.5,
      ),
      errorBorder: _crearBorde(color: errorColor),
      focusedErrorBorder: _crearBorde(color: errorColor, ancho: 1.5),
      errorStyle: GoogleFonts.inter(color: errorColor, fontSize: 11),
    );
  }

  static OutlineInputBorder _crearBorde({Color? color, double ancho = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: BorderSide(
        color: color ?? Colors.white.withValues(alpha: 0.08),
        width: ancho,
      ),
    );
  }

  static BoxDecoration get cardDecoracion => BoxDecoration(
        color: Colors.white.withValues(alpha: opacidadFondoCard),
        borderRadius: BorderRadius.circular(radiusLg),
        border:
            Border.all(color: Colors.white.withValues(alpha: opacidadBorde)),
      );

  static BoxDecoration get cardDestacadoDecoracion => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D1066), Color(0xFF6B0F4A)],
        ),
        borderRadius: BorderRadius.circular(radiusXl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B0F4A).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration categoriaDecoracion(bool esSeleccionado) {
    return BoxDecoration(
      color: esSeleccionado
          ? primaryYellow.withValues(alpha: 0.12)
          : Colors.white.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(radiusMd),
      border: Border.all(
        color: esSeleccionado
            ? primaryYellow.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.08),
        width: 1.5,
      ),
    );
  }

  static BoxDecoration get botonPrimaryDecoracion => BoxDecoration(
        gradient: buttonGradient,
        borderRadius: BorderRadius.circular(radiusLg),
        boxShadow: [
          BoxShadow(
            color: primaryPink.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get botonPrimaryDeshabilitadoDecoracion => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radiusLg),
      );

  static BoxDecoration get botonAtrasDecoracion => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(radiusMd),
        border:
            Border.all(color: Colors.white.withValues(alpha: opacidadBorde)),
      );

  static BoxDecoration get botonPrimarioCircular => BoxDecoration(
        gradient: buttonGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryPink.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration get barraBusquedaDecoracion => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(radiusFull),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.08)),
      );

  static BoxDecoration get navBarDecoracion => BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        border: Border(
          top: BorderSide(
              color: Colors.white.withValues(alpha: 0.06), width: 1),
        ),
      );

  static BoxDecoration get botonCircularDecoracion => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.white.withValues(alpha: opacidadBorde)),
      );

  // --- SNACKBARS ---
  static SnackBar snackbarError(String mensaje) =>
      _generarSnackBar(mensaje, errorColor, Icons.error_outline);

  static SnackBar snackbarExito(String mensaje) =>
      _generarSnackBar(mensaje, successColor, Icons.check_circle_outline);

  static SnackBar _generarSnackBar(
      String mensaje, Color fondo, IconData icono) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icono, color: textColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(mensaje,
                style: GoogleFonts.inter(color: textColor, fontSize: 13)),
          ),
        ],
      ),
      backgroundColor: fondo,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd)),
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
        error: errorColor,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        titleTextStyle: GoogleFonts.outfit(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
