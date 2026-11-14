// filepath: /home/mohamed/APP/test_game/lib/quations.dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'question_brain.dart';

const Color _emerald = Color(0xFF087F5B);
const Color _deepGreen = Color(0xFF064E3B);
const Color _gold = Color(0xFFD4AF37);
const Color _warmWhite = Color(0xFFFAFAF5);
const Color _lightBackground = Color(0xFFF3F6F2);
const Color _darkText = Color(0xFF1F2937);

QuestionBrain questionBrain = QuestionBrain();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int correctAnswersCount = 0;
  int answeredQuestions = 0;
  bool _answeredCurrentQuestion = false;

  void checkAnswer({required String selectedOption}) {
    if (_answeredCurrentQuestion) return;

    _answeredCurrentQuestion = true;
    final isCorrect = selectedOption == questionBrain.getQuestionCorrect();

    setState(() {
      answeredQuestions++;
      if (isCorrect) correctAnswersCount++;

      answerResults.add(
        Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? _emerald : Colors.redAccent,
            semanticLabel: isCorrect ? 'إجابة صحيحة' : 'إجابة خاطئة',
          ),
        ),
      );
    });

    if (questionBrain.isFinished()) {
      final total = questionBrain.totalQuestions;
      final percentage = total == 0 ? 0.0 : correctAnswersCount / total * 100;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => _ResultPreparationScreen(
            correctAnswers: correctAnswersCount,
            totalQuestions: total,
            percentage: percentage,
          ),
        ),
      );
      return;
    }

    questionBrain.nextQuestion();
    setState(() => _answeredCurrentQuestion = false);
  }

  final List<Widget> answerResults = [];

  @override
  Widget build(BuildContext context) {
    final total = questionBrain.totalQuestions;
    final questionNumber = questionBrain.questionIndex + 1;
    final progress = total == 0
        ? 0.0
        : (answeredQuestions / total).clamp(0.0, 1.0);

    final options = [
      questionBrain.getQestionOptin1(),
      questionBrain.getQestionOptin2(),
      questionBrain.getQestionOptin3(),
      questionBrain.getQestionOptin4(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _lightBackground,
        appBar: AppBar(
          title: const Text('اختبار ديني'),
          backgroundColor: _deepGreen,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: _warmWhite,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'السؤال $questionNumber من $total',
                                    style: const TextStyle(
                                      color: _darkText,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${(progress * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      color: _emerald,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFFE2E8E2),
                                  valueColor: const AlwaysStoppedAnimation(
                                    _emerald,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(spacing: 2, children: answerResults),
                      Card(
                        color: _warmWhite,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.asset(
                                  questionBrain.getQestionImage(),
                                  height: 190,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const SizedBox(
                                    height: 190,
                                    child: Center(
                                      child: Icon(
                                        Icons.mosque,
                                        size: 64,
                                        color: _emerald,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                questionBrain.getQestion(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: _darkText,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...options.map(
                        (option) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _answeredCurrentQuestion
                                  ? null
                                  : () => checkAnswer(selectedOption: option),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _deepGreen,
                                disabledForegroundColor: _deepGreen,
                                disabledBackgroundColor: Colors.white,
                                elevation: 1,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                    color: Color(0xFFDDE7DF),
                                  ),
                                ),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('الرئيسية'),
            style: OutlinedButton.styleFrom(
              foregroundColor: _deepGreen,
              minimumSize: const Size.fromHeight(52),
              side: const BorderSide(color: _emerald),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
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
        backgroundColor: _deepGreen,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mosque, size: 84, color: _gold),
                const SizedBox(height: 16),
                const Text(
                  'اختبار ديني',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),
                const CircularProgressIndicator(color: _gold),
                const SizedBox(height: 18),
                const Text(
                  'جاري تجهيز نتيجتك...',
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
    if (percentage >= 90) return 'ممتاز!';
    if (percentage >= 80) return 'جيد جداً!';
    if (percentage >= 60) return 'جيد!';
    if (percentage >= 40) return 'يمكنك التحسن!';
    return 'لا تستسلم، حاول مرة أخرى!';
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
        backgroundColor: _lightBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  color: _warmWhite,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mosque, size: 60, color: _emerald),
                        const SizedBox(height: 12),
                        const Text(
                          'اختبار ديني',
                          style: TextStyle(
                            color: _deepGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'أحسنت! لقد أكملت المسابقة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _darkText,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: safePercentage,
                                  strokeWidth: 12,
                                  backgroundColor: const Color(0xFFE2E8E2),
                                  valueColor: const AlwaysStoppedAnimation(
                                    _emerald,
                                  ),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: _deepGreen,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          evaluation,
                          style: const TextStyle(
                            color: _emerald,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _scoreRow('الإجابات الصحيحة', correctAnswers),
                        _scoreRow('الإجابات الخاطئة', incorrectAnswers),
                        _scoreRow('مجموع الأسئلة', totalQuestions),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst),
                            icon: const Icon(Icons.home_outlined),
                            label: const Text('العودة للرئيسية'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _deepGreen,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(52),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _restart(context),
                            icon: const Icon(Icons.replay),
                            label: const Text('إعادة المسابقة'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _deepGreen,
                              minimumSize: const Size.fromHeight(52),
                              side: const BorderSide(color: _emerald),
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

  Widget _scoreRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: _darkText)),
          Text(
            '$value',
            style: const TextStyle(
              color: _deepGreen,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
