import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_game/quations.dart';
import 'package:test_game/question_brain.dart';

void main() {
  // إعادة ضبط حالة الأسئلة قبل كل اختبار لضمان العزل
  setUp(() {
    questionBrain.reset();
  });

  // ───────────────────────────────────────────────────────────
  // 1) شاشة الأسئلة تعرض السؤال وأربعة خيارات
  // ───────────────────────────────────────────────────────────
  testWidgets('شاشة الأسئلة تعرض السؤال وأربعة خيارات',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));
    await tester.pumpAndSettle();

    // السؤال الأول موجود
    expect(find.text('ما اسم النبي الذي ابتلعه الحوت؟'), findsOneWidget);

    // 4 خيارات (InkWell وليس ElevatedButton في التصميم الجديد)
    expect(find.byType(InkWell), findsNWidgets(4));

    // عنوان شريط التطبيق
    expect(find.text('اختبار ديني'), findsOneWidget);
  });

  // ───────────────────────────────────────────────────────────
  // 2) بعد الإجابة يظهر زر "السؤال التالي"
  // ───────────────────────────────────────────────────────────
  testWidgets('بعد الإجابة يظهر زر الانتقال للسؤال التالي',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));
    await tester.pumpAndSettle();

    // اضغط على أول خيار
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // زر "السؤال التالي" ظهر
    expect(find.text('السؤال التالي'), findsOneWidget);
  });

  // ───────────────────────────────────────────────────────────
  // 3) الانتقال للسؤال التالي يغيّر نص السؤال
  // ───────────────────────────────────────────────────────────
  testWidgets('الانتقال للسؤال التالي يغيّر السؤال',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Home()));
    await tester.pumpAndSettle();

    // الإجابة على السؤال الأول
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    // الضغط على "السؤال التالي"
    await tester.tap(find.text('السؤال التالي'));
    await tester.pumpAndSettle();

    // السؤال الثاني ظهر
    expect(
      find.text('من هو النبي الذي أُرسل إلى قوم ثمود؟'),
      findsOneWidget,
    );

    // شريط التقدم يعرض "السؤال 2 من 30"
    expect(find.textContaining('السؤال 2 من'), findsOneWidget);
  });

  // ───────────────────────────────────────────────────────────
  // 4) زر الرئيسية يعيدنا لشاشة الترحيب
  // ───────────────────────────────────────────────────────────
  testWidgets('زر الرئيسية في AppBar يعمل',
      (WidgetTester tester) async {
    // نبني شاشة ترحيب بسيطة ثم ننتقل إلى Home
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('WELCOME'))),
      ),
    );

    // ندخل إلى Home يدويًا
    await tester.pumpWidget(const MaterialApp(home: Home()));
    await tester.pumpAndSettle();

    // نضغط أيقونة الرئيسية في AppBar
    await tester.tap(find.byIcon(Icons.home_outlined).first);
    await tester.pumpAndSettle();

    // لا نتحقق من شاشة محددة لأننا لم نبنِ شجرة تنقّل كاملة،
    // يكفي التأكد أن المؤشر لم يبقَ على Home
    expect(find.byType(Home), findsNothing);
  });

  // ───────────────────────────────────────────────────────────
  // 5) اختبار منطق QuestionBrain (بدون واجهة)
  // ───────────────────────────────────────────────────────────
  test('QuestionBrain يبدأ من السؤال الأول', () {
    final brain = QuestionBrain();
    expect(brain.questionIndex, 0);
    expect(brain.totalQuestions, 30);
    expect(brain.getQestion(), 'ما اسم النبي الذي ابتلعه الحوت؟');
  });

  test('QuestionBrain ينتقل ويُعيد الضبط', () {
    final brain = QuestionBrain();
    brain.nextQuestion();
    expect(brain.questionIndex, 1);
    brain.reset();
    expect(brain.questionIndex, 0);
  });

  test('QuestionBrain isFinished يعمل بشكل صحيح', () {
    final brain = QuestionBrain();
    // نقفز للسؤال قبل الأخير
    for (int i = 0; i < brain.totalQuestions - 1; i++) {
      brain.nextQuestion();
    }
    expect(brain.isFinished(), isTrue);
    brain.reset();
    expect(brain.isFinished(), isFalse);
  });
}