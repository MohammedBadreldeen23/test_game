import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_theme.dart';
import 'audio_service.dart';
import 'question_brain.dart';

QuestionBrain questionBrain = QuestionBrain();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _answeredCurrentQuestion = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _answeredCurrentQuestion = questionBrain.isCurrentAnswered();
    _selectedAnswer = questionBrain.getSelectedAnswerForCurrent();
  }

  void _handleAnswer(String option) {
    if (_answeredCurrentQuestion) return;
    HapticFeedback.lightImpact();

    final isCorrect = option == questionBrain.getQuestionCorrect();

    if (isCorrect) {
      AudioService.playCorrect();
    } else {
      AudioService.playWrong();
    }

    questionBrain.recordAnswer(option);

    setState(() {
      _answeredCurrentQuestion = true;
      _selectedAnswer = option;
    });
  }

  void _goToNext() {
    if (questionBrain.isFinished()) {
      final total = questionBrain.totalQuestions;
      final correct = questionBrain.correctAnswersCount;
      final percentage = total == 0 ? 0.0 : correct / total * 100;

      questionBrain.reset();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => _ResultPreparationScreen(
            correctAnswers: correct,
            totalQuestions: total,
            percentage: percentage,
          ),
        ),
      );
      return;
    }

    questionBrain.nextQuestion();
    setState(() {
      _answeredCurrentQuestion = questionBrain.isCurrentAnswered();
      _selectedAnswer = questionBrain.getSelectedAnswerForCurrent();
    });
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من عرض الشاشة (للأجهزة اللوحية والويب)
    final isWide = MediaQuery.of(context).size.width >= 800;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: lightBackground,
        appBar: AppBar(
          title: Text(
            'اختبار ديني',
            style: cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: deepGreen,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          actions: [
            ValueListenableBuilder<bool>(
              valueListenable: AudioService.muted,
              builder: (context, isMuted, _) {
                return IconButton(
                  tooltip: isMuted ? 'تشغيل الصوت' : 'كتم الصوت',
                  icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    AudioService.muted.value = !isMuted;
                    HapticFeedback.selectionClick();
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.home_outlined),
              tooltip: 'الرئيسية',
              onPressed: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          ],
        ),
        // المحتوى الأساسي
        body: SafeArea(
          child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ),
        
        // ✅ الزر ثابت في الأسفل (يظهر دائماً ولا يختفي مع التمرير)
        bottomNavigationBar: _answeredCurrentQuestion
            ? SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          _goToNext();
                        },
                        icon: Icon(
                          questionBrain.isFinished()
                              ? Icons.flag_outlined
                              : Icons.arrow_back,
                          size: 22,
                        ),
                        label: Text(
                          questionBrain.isFinished()
                              ? 'عرض النتيجة'
                              : 'السؤال التالي',
                          style: cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emerald,
                          foregroundColor: Colors.white,
                          elevation: 6, // إضافة ظل ليبرز الزر
                          shadowColor: emerald.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // 📱 تخطيط الهاتف (عمودي)
  // ═══════════════════════════════════════════════════════
  Widget _buildNarrowLayout() {
    final total = questionBrain.totalQuestions;
    final questionNumber = questionBrain.questionIndex + 1;
    final progress = total == 0
        ? 0.0
        : (questionBrain.answeredQuestions / total).clamp(0.0, 1.0);

    final options = [
      questionBrain.getQestionOptin1(),
      questionBrain.getQestionOptin2(),
      questionBrain.getQestionOptin3(),
      questionBrain.getQestionOptin4(),
    ];

    return SingleChildScrollView(
      // مسافة سفلية كافية لكي لا يغطي الزر الثابت الخيار الأخير
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressCard(questionNumber, total, progress),
          const SizedBox(height: 14),
          _buildQuestionCard(questionNumber),
          _buildFeedbackBanner(),
          const SizedBox(height: 16),
          ...options.map(_buildOption),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // 💻 تخطيط الويب/التابلت (عمودان)
  // ═══════════════════════════════════════════════════════
  Widget _buildWideLayout() {
    final total = questionBrain.totalQuestions;
    final questionNumber = questionBrain.questionIndex + 1;
    final progress = total == 0
        ? 0.0
        : (questionBrain.answeredQuestions / total).clamp(0.0, 1.0);

    final options = [
      questionBrain.getQestionOptin1(),
      questionBrain.getQestionOptin2(),
      questionBrain.getQestionOptin3(),
      questionBrain.getQestionOptin4(),
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العمود الأيمن (السؤال)
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProgressCard(questionNumber, total, progress),
                    const SizedBox(height: 16),
                    _buildQuestionCard(questionNumber),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // العمود الأيسر (الخيارات)
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFeedbackBanner(),
                    const SizedBox(height: 12),
                    ...options.map(_buildOption),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // 🧩 المكوّنات المشتركة
  // ═══════════════════════════════════════════════════════

  Widget _buildProgressCard(int questionNumber, int total, double progress) {
    return Card(
      color: warmWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السؤال $questionNumber من $total',
                  style: cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: emerald.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: emerald),
                      const SizedBox(width: 4),
                      Text(
                        '${questionBrain.correctAnswersCount}',
                        style: cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: emerald,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 450),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE2E8E2),
                  valueColor: const AlwaysStoppedAnimation(emerald),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int questionNumber) {
    return Card(
      color: warmWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [emerald, deepGreen],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: emerald.withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$questionNumber',
                      style: cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'السؤال رقم $questionNumber',
                    style: cairo(
                      fontSize: 14,
                      color: darkText.withOpacity(0.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              questionBrain.getQestion(),
              style: cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.6,
                color: darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackBanner() {
    if (!_answeredCurrentQuestion) return const SizedBox.shrink();

    final isCorrect = _selectedAnswer == questionBrain.getQuestionCorrect();
    final accentColor = isCorrect ? correctGreen : wrongRed;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withOpacity(0.35), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: accentColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isCorrect
                    ? 'إجابة صحيحة! أحسنت'
                    : 'إجابة خاطئة. الصحيح: ${questionBrain.getQuestionCorrect()}',
                style: cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    final isAnswered = _answeredCurrentQuestion;
    final isCorrect = option == questionBrain.getQuestionCorrect();
    final isSelected = option == _selectedAnswer;

    Color bg, fg, border;
    IconData? trailing;
    double opacity = 1.0;

    if (!isAnswered) {
      bg = Colors.white;
      fg = deepGreen;
      border = const Color(0xFFDDE7DF);
    } else if (isCorrect) {
      bg = correctGreen;
      fg = Colors.white;
      border = correctGreen;
      trailing = Icons.check_circle_outline;
    } else if (isSelected) {
      bg = wrongRed;
      fg = Colors.white;
      border = wrongRed;
      trailing = Icons.highlight_off;
    } else {
      bg = Colors.white;
      fg = darkText.withOpacity(0.55);
      border = const Color(0xFFE5E7EB);
      opacity = 0.55;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: opacity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.5),
            boxShadow: isAnswered
                ? const []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isAnswered ? null : () => _handleAnswer(option),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        textAlign: TextAlign.right,
                        style: cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: fg,
                        ),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 10),
                      Icon(trailing, color: fg, size: 22),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// بقية الكود (شاشة التجهيز والنتيجة) كما هو دون تغيير ...
// ═══════════════════════════════════════════════════════════
class _ResultPreparationScreen extends StatefulWidget {
  const _ResultPreparationScreen({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percentage,
  });

  final int correctAnswers;
  final int totalQuestions;
  final double percentage;

  @override
  State<_ResultPreparationScreen> createState() =>
      _ResultPreparationScreenState();
}

class _ResultPreparationScreenState extends State<_ResultPreparationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AudioService.playFireworks();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat(reverse: true);

    _timer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => _QuizResultScreen(
            correctAnswers: widget.correctAnswers,
            totalQuestions: widget.totalQuestions,
            percentage: widget.percentage,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: deepGreen,
        body: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mosque, size: 84, color: gold),
                const SizedBox(height: 16),
                Text(
                  'اختبار ديني',
                  style: amiri(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                const CircularProgressIndicator(color: gold),
                const SizedBox(height: 18),
                Text(
                  'جاري تجهيز نتيجتك...',
                  style: cairo(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizResultScreen extends StatelessWidget {
  const _QuizResultScreen({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percentage,
  });

  final int correctAnswers;
  final int totalQuestions;
  final double percentage;

  String get evaluation {
    if (percentage >= 90) return 'ممتاز! ما شاء الله';
    if (percentage >= 80) return 'جيد جدًا!';
    if (percentage >= 60) return 'جيد، واصل التقدم';
    if (percentage >= 40) return 'يمكنك التحسن';
    return 'لا تستسلم، حاول مرة أخرى';
  }

  int get starCount {
    if (percentage >= 90) return 3;
    if (percentage >= 60) return 2;
    if (percentage >= 40) return 1;
    return 0;
  }

  void _restart(BuildContext context) {
    questionBrain.reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const Home()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final incorrectAnswers = totalQuestions - correctAnswers;
    final safePercentage = (percentage / 100).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: lightBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  color: warmWhite,
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mosque, size: 50, color: emerald),
                        const SizedBox(height: 8),
                        Text(
                          'اختبار ديني',
                          style: amiri(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: deepGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'أحسنت! لقد أكملت المسابقة',
                          textAlign: TextAlign.center,
                          style: cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: safePercentage,
                                  strokeWidth: 10,
                                  backgroundColor: const Color(0xFFE2E8E2),
                                  valueColor:
                                      const AlwaysStoppedAnimation(emerald),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: cairo(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: deepGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                i < starCount
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: i < starCount
                                    ? gold
                                    : Colors.grey.shade300,
                                size: 36,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          evaluation,
                          textAlign: TextAlign.center,
                          style: cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: emerald,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFE2E8E2), width: 1),
                          ),
                          child: Column(
                            children: [
                              _scoreRow('الإجابات الصحيحة', correctAnswers,
                                  color: correctGreen),
                              const Divider(height: 16),
                              _scoreRow('الإجابات الخاطئة', incorrectAnswers,
                                  color: wrongRed),
                              const Divider(height: 16),
                              _scoreRow('مجموع الأسئلة', totalQuestions,
                                  color: darkText),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                            icon: const Icon(Icons.home_outlined),
                            label: Text(
                              'العودة للرئيسية',
                              style: cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: deepGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _restart(context),
                            icon: const Icon(Icons.replay),
                            label: Text(
                              'إعادة المسابقة',
                              style: cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: deepGreen,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: deepGreen,
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(color: emerald),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreRow(String label, int value, {required Color color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: cairo(fontSize: 15, color: darkText)),
        Text(
          '$value',
          style: cairo(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}