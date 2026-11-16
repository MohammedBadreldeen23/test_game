import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quations.dart';
import 'app_theme.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Exzam());
}

class Exzam extends StatelessWidget {
  const Exzam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اختبار ديني',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: emerald),
        scaffoldBackgroundColor: lightBackground,
        textTheme: GoogleFonts.cairoTextTheme(), // ← يفعّل Cairo كنص افتراضي
      ),
      home: const ExamPage(),
    );
  }
}

// مساعد بسيط لتطبيق خط Cairo افتراضيًا
class GoogleFontsCairoHelper {
  static String? get fontFamily => GoogleFontsProxy.cairoFamily;
}

// استخدمنا هذا للفصل حتى لا يكسر بناء الثيم
class GoogleFontsProxy {
  static String? get cairoFamily {
    // نرجع اسم عائلة Cairo الذي تسجله google_fonts
    return 'Cairo';
  }
}

// ═══════════════════════════════════════════════════════
// 🕌 شاشة الترحيب (Welcome)
// ═══════════════════════════════════════════════════════
class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [deepGreen, Color(0xFF0B7A5A)],
            ),
          ),
          child: Stack(
            children: [
              // زخرفة هندسية إسلامية خفيفة (تُرسم بالكود)
              const Positioned.fill(
                child: CustomPaint(painter: _IslamicPatternPainter()),
              ),
              // محتوى
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // الشعار
                            Container(
                              width: 122,
                              height: 122,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 3),
                                color: Colors.white.withValues(alpha: 0.08),
                                boxShadow: [
                                  BoxShadow(
                                    color: gold.withValues(alpha: 0.35),
                                    blurRadius: 32,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mosque,
                                size: 64,
                                color: gold,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'اختبار ديني',
                              style: amiri(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 64,
                              height: 3,
                              decoration: BoxDecoration(
                                color: gold,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'اختبر معرفتك بالإسلام وتعاليمه',
                              textAlign: TextAlign.center,
                              style: cairo(
                                fontSize: 17,
                                color: Colors.white.withValues(alpha: 0.88),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 34),
                            // شرائح معلومات
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _infoChip(Icons.help_outline, '30 سؤالًا'),
                                _infoChip(Icons.school_outlined, 'متنوع وشامل'),
                                _infoChip(Icons.timer_outlined, '10–15 دقيقة'),
                              ],
                            ),
                            const SizedBox(height: 42),
                            // زر البدء
                            SizedBox(
                              width: double.infinity,
                              height: 62,
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Home(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: gold,
                                  foregroundColor: deepGreen,
                                  elevation: 12,
                                  shadowColor: gold.withValues(alpha: 0.55),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'ابدأ الاختبار',
                                      style: cairo(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.arrow_back, size: 22),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              'بسم الله الرحمن الرحيم',
                              style: amiri(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.65),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('جميع الحقوق محفوظة © 2026',
                                style: cairo(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.55),
                                )
                                ),
                                const SizedBox(height: 4),
                            Text('تم التطوير بواسطة: محمد بدر الدين البلال',
                                style: cairo(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.55),
                                )
                                ),
                                
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: gold),
          const SizedBox(width: 6),
          Text(
            text,
            style: cairo(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// 🕌 زخرفة هندسية (نجوم ثمانية إسلامية) مرسومة بالكود
class _IslamicPatternPainter extends CustomPainter {
  const _IslamicPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const double spacing = 92;
    const double r = 26;

    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing) {
        _drawStar(canvas, Offset(x, y), r, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint p) {
    // مربع مائل (45°)
    final path = Path();
    final d = r * 0.7071;
    path.moveTo(c.dx, c.dy - d);
    path.lineTo(c.dx + d, c.dy);
    path.lineTo(c.dx, c.dy + d);
    path.lineTo(c.dx - d, c.dy);
    path.close();
    canvas.drawPath(path, p);
    // مربع مستقيم متراكب
    canvas.drawRect(Rect.fromCenter(center: c, width: r, height: r), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
