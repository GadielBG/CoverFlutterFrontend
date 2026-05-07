import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
    );

    _glowAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Fondo con gradiente radial
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, __) => CustomPaint(
                painter: _GlowPainter(_glowAnim.value),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo animado
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.buttonGradient,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPink.withValues(alpha: 0.5),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.nightlife_rounded,
                      size: 52,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Título COVER
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.buttonGradient.createShader(bounds),
                    child: Text(
                      'COVER',
                      style: GoogleFonts.outfit(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                FadeTransition(
                  opacity: _fadeAnim,
                  child: Text(
                    'Tu vida nocturna, en tus manos',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.4),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Barra de carga degradada
                FadeTransition(
                  opacity: _fadeAnim,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => Container(
                      width: 120,
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _controller.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.buttonGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  final double progress;
  _GlowPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFF7BDA).withValues(alpha: 0.12 * progress),
          const Color(0xFFD3FF00).withValues(alpha: 0.06 * progress),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.progress != progress;
}
