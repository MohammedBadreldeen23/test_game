import 'quiz_question.dart';

class QuestionBrain {
  int _questionIndex = 0;

  // ✅ تخزين الإجابات والنقاط هنا لتبقى محفوظة
  final Map<int, String> _selectedAnswers = {};
  int _correctCount = 0;

  final List<QuizQuestion> _quizQuestions = [
    QuizQuestion(
      question: 'ما اسم النبي الذي ابتلعه الحوت؟',
      option1: 'أ. موسى',
      option2: 'ب. يونس',
      option3: 'ج. إبراهيم',
      option4: 'د. نوح',
      answer: 'ب. يونس',
    ),
    QuizQuestion(
      question: 'ما اسم أول سورة في ترتيب المصحف الشريف؟',
      option1: 'أ. البقرة',
      option2: 'ب. الإخلاص',
      option3: 'ج. الفاتحة',
      option4: 'د. الناس',
      answer: 'ج. الفاتحة',
    ),
    QuizQuestion(
      question: 'من هو النبي الذي أُرسل إلى قوم ثمود؟',
      option1: 'أ. هود',
      option2: 'ب. صالح',
      option3: 'ج. شعيب',
      option4: 'د. لوط',
      answer: 'ب. صالح',
    ),
    QuizQuestion(
      question: 'ما هو الكتاب الذي أُنزل على موسى عليه السلام؟',
      option1: 'أ. التوراة',
      option2: 'ب. الإنجيل',
      option3: 'ج. الزبور',
      option4: 'د. الصحف',
      answer: 'أ. التوراة',
    ),
    QuizQuestion(
      question: 'ما هو الكتاب الذي أُنزل على عيسى عليه السلام؟',
      option1: 'أ. التوراة',
      option2: 'ب. الإنجيل',
      option3: 'ج. الزبور',
      option4: 'د. القرآن',
      answer: 'ب. الإنجيل',
    ),
    QuizQuestion(
      question: 'في أي شهر يصوم المسلمون؟',
      option1: 'أ. شعبان',
      option2: 'ب. شوال',
      option3: 'ج. محرم',
      option4: 'د. رمضان',
      answer: 'د. رمضان',
    ),
    QuizQuestion(
      question: 'ما هي السورة التي لا تبدأ بالبسملة؟',
      option1: 'أ. سورة التوبة',
      option2: 'ب. سورة الأنفال',
      option3: 'ج. سورة النمل',
      option4: 'د. سورة هود',
      answer: 'أ. سورة التوبة',
    ),
    QuizQuestion(
      question: 'ما اسم السورة التي وردت فيها البسملة مرتين؟',
      option1: 'أ. سورة القصص',
      option2: 'ب. سورة النحل',
      option3: 'ج. سورة النمل',
      option4: 'د. سورة الإسراء',
      answer: 'ج. سورة النمل',
    ),
    QuizQuestion(
      question: 'كم سنة لبث أصحاب الكهف في كهفهم كما ذكر القرآن؟',
      option1: 'أ. 100 سنة',
      option2: 'ب. 200 سنة',
      option3: 'ج. 309 سنوات',
      option4: 'د. 500 سنة',
      answer: 'ج. 309 سنوات',
    ),
    QuizQuestion(
      question: 'كم عدد سور القرآن الكريم؟',
      option1: 'أ. 110 سور',
      option2: 'ب. 112 سورة',
      option3: 'ج. 113 سورة',
      option4: 'د. 114 سورة',
      answer: 'د. 114 سورة',
    ),
    QuizQuestion(
      question: 'ما هي القبلة الأولى للمسلمين؟',
      option1: 'أ. المسجد النبوي',
      option2: 'ب. المسجد الحرام',
      option3: 'ج. المسجد الأقصى',
      option4: 'د. مسجد قباء',
      answer: 'ج. المسجد الأقصى',
    ),
    QuizQuestion(
      question: 'ما آخر سورة نزلت كاملة من القرآن الكريم؟',
      option1: 'أ. سورة التوبة',
      option2: 'ب. سورة النصر',
      option3: 'ج. سورة المائدة',
      option4: 'د. سورة الفتح',
      answer: 'ب. سورة النصر',
    ),
    QuizQuestion(
      question: 'كم عدد الملائكة الذين أمدّ الله بهم المسلمين في غزوة بدر وفق سورة الأنفال؟',
      option1: 'أ. 500 ملك',
      option2: 'ب. 700 ملك',
      option3: 'ج. 1000 ملك',
      option4: 'د. 3000 ملك',
      answer: 'ج. 1000 ملك',
    ),
    QuizQuestion(
      question: 'من هو الصحابي الذي كان يُعرف بصاحب سر رسول الله ﷺ؟',
      option1: 'أ. أبو عبيدة بن الجراح',
      option2: 'ب. عبد الله بن مسعود',
      option3: 'ج. حذيفة بن اليمان',
      option4: 'د. زيد بن ثابت',
      answer: 'ج. حذيفة بن اليمان',
    ),
    QuizQuestion(
      question: 'من هو النبي الذي بنى الكعبة مع ابنه إسماعيل؟',
      option1: 'أ. إبراهيم',
      option2: 'ب. نوح',
      option3: 'ج. آدم',
      option4: 'د. يعقوب',
      answer: 'أ. إبراهيم',
    ),
    QuizQuestion(
      question: 'كم عدد أجزاء القرآن الكريم؟',
      option1: 'أ. عشرون جزءًا',
      option2: 'ب. خمسة وعشرون جزءًا',
      option3: 'ج. أربعون جزءًا',
      option4: 'د. ثلاثون جزءًا',
      answer: 'د. ثلاثون جزءًا',
    ),
    QuizQuestion(
      question: 'ما هي أطول سورة في القرآن الكريم؟',
      option1: 'أ. سورة آل عمران',
      option2: 'ب. سورة البقرة',
      option3: 'ج. سورة النساء',
      option4: 'د. سورة المائدة',
      answer: 'ب. سورة البقرة',
    ),
    QuizQuestion(
      question: 'ما هي أقصر سورة في القرآن الكريم؟',
      option1: 'أ. سورة العصر',
      option2: 'ب. سورة الإخلاص',
      option3: 'ج. سورة الناس',
      option4: 'د. سورة الكوثر',
      answer: 'د. سورة الكوثر',
    ),
    QuizQuestion(
      question: 'في أي ليلة أُنزل القرآن الكريم؟',
      option1: 'أ. ليلة الإسراء',
      option2: 'ب. ليلة النصف من شعبان',
      option3: 'ج. ليلة القدر',
      option4: 'د. ليلة الجمعة',
      answer: 'ج. ليلة القدر',
    ),
    QuizQuestion(
      question: 'كم عدد أركان الإسلام؟',
      option1: 'أ. ثلاثة',
      option2: 'ب. خمسة',
      option3: 'ج. ستة',
      option4: 'د. سبعة',
      answer: 'ب. خمسة',
    ),
    QuizQuestion(
      question: 'ما هو أول أركان الإسلام؟',
      option1: 'أ. الشهادتان',
      option2: 'ب. الصلاة',
      option3: 'ج. الزكاة',
      option4: 'د. الصيام',
      answer: 'أ. الشهادتان',
    ),
    QuizQuestion(
      question: 'كم عدد أركان الإيمان؟',
      option1: 'أ. خمسة',
      option2: 'ب. سبعة',
      option3: 'ج. ستة',
      option4: 'د. أربعة',
      answer: 'ج. ستة',
    ),
    QuizQuestion(
      question: 'كم عدد الصلوات المفروضة في اليوم والليلة؟',
      option1: 'أ. ثلاث صلوات',
      option2: 'ب. خمس صلوات',
      option3: 'ج. سبع صلوات',
      option4: 'د. أربع صلوات',
      answer: 'ب. خمس صلوات',
    ),
    QuizQuestion(
      question: 'في أي مدينة وُلد النبي محمد ﷺ؟',
      option1: 'أ. المدينة المنورة',
      option2: 'ب. مكة المكرمة',
      option3: 'ج. الطائف',
      option4: 'د. القدس',
      answer: 'ب. مكة المكرمة',
    ),
    QuizQuestion(
      question: 'ما اسم والدة النبي محمد ﷺ؟',
      option1: 'أ. خديجة بنت خويلد',
      option2: 'ب. آمنة بنت وهب',
      option3: 'ج. فاطمة بنت أسد',
      option4: 'د. حليمة السعدية',
      answer: 'ب. آمنة بنت وهب',
    ),
    QuizQuestion(
      question: 'من هي أول زوجات النبي ﷺ؟',
      option1: 'أ. خديجة بنت خويلد',
      option2: 'ب. عائشة بنت أبي بكر',
      option3: 'ج. حفصة بنت عمر',
      option4: 'د. زينب بنت جحش',
      answer: 'أ. خديجة بنت خويلد',
    ),
    QuizQuestion(
      question: 'ما اسم الغار الذي نزل فيه الوحي أول مرة على النبي ﷺ؟',
      option1: 'أ. غار ثور',
      option2: 'ب. غار الكهف',
      option3: 'ج. غار حراء',
      option4: 'د. غار بدر',
      answer: 'ج. غار حراء',
    ),
    QuizQuestion(
      question: 'في أي شهر هجري وقعت غزوة بدر الكبرى؟',
      option1: 'أ. شعبان',
      option2: 'ب. شوال',
      option3: 'ج. محرم',
      option4: 'د. رمضان',
      answer: 'د. رمضان',
    ),
    QuizQuestion(
      question: 'من هو أول الخلفاء الراشدين؟',
      option1: 'أ. أبو بكر الصديق',
      option2: 'ب. عمر بن الخطاب',
      option3: 'ج. عثمان بن عفان',
      option4: 'د. علي بن أبي طالب',
      answer: 'أ. أبو بكر الصديق',
    ),
    QuizQuestion(
      question: 'كم عدد الأشهر الحرم في الإسلام؟',
      option1: 'أ. شهران',
      option2: 'ب. ثلاثة',
      option3: 'ج. أربعة',
      option4: 'د. خمسة',
      answer: 'ج. أربعة',
    ),
  ];

  String getQuestionCorrect() => _quizQuestions[_questionIndex].answer;
  String getQestionOptin1() => _quizQuestions[_questionIndex].option1;
  String getQestionOptin2() => _quizQuestions[_questionIndex].option2;
  String getQestionOptin3() => _quizQuestions[_questionIndex].option3;
  String getQestionOptin4() => _quizQuestions[_questionIndex].option4;
  String getQestion() => _quizQuestions[_questionIndex].question;

  // ✅ الدوال الجديدة لإدارة الحالة
  bool isCurrentAnswered() => _selectedAnswers.containsKey(_questionIndex);
  String? getSelectedAnswerForCurrent() => _selectedAnswers[_questionIndex];

  void recordAnswer(String selected) {
    if (_selectedAnswers.containsKey(_questionIndex)) return;
    _selectedAnswers[_questionIndex] = selected;
    if (selected == getQuestionCorrect()) _correctCount++;
  }

  int get correctAnswersCount => _correctCount;
  int get answeredQuestions => _selectedAnswers.length;

  bool isFinished() => _questionIndex >= _quizQuestions.length - 1;

  void nextQuestion() {
    if (!isFinished()) _questionIndex++;
  }

  void reset() {
    _questionIndex = 0;
    _selectedAnswers.clear();
    _correctCount = 0;
  }

  int get questionIndex => _questionIndex;
  int get totalQuestions => _quizQuestions.length;
}