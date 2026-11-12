import 'package:flutter/material.dart';
import 'quiz_question.dart';
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'اختبار ديني',

            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 10, 20, 30),
        ),
        body: Padding(padding: const EdgeInsets.all(20.0), child: Quations()),
      ),
    );
  }
}

class Quations extends StatefulWidget {
  const Quations({super.key});

  @override
  State<Quations> createState() => _QuationsState();
}

class _QuationsState extends State<Quations> {

  List<Padding> answerResults = [];
 List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'ما اسم النبي الذي ابتلعه الحوت؟',
    option1: 'أ. موسى',
    option2: 'ب. يونس',
    option3: 'ج. إبراهيم',
    option4: 'د. نوح',
    answer: 'ب. يونس',
    image: 'images/Q1.png'
  ),
  QuizQuestion(
    question: 'ما اسم أول سورة في ترتيب المصحف الشريف؟',
    option1: 'أ. البقرة',
    option2: 'ب. الإخلاص',
    option3: 'ج. الفاتحة',
    option4: 'د. الناس',
    answer: 'ج. الفاتحة',
    image: 'images/Q2.png'
  ),
  QuizQuestion(
    question: 'من هو النبي الذي أُرسل إلى قوم ثمود؟',
    option1: 'أ. هود',
    option2: 'ب. صالح',
    option3: 'ج. شعيب',
    option4: 'د. لوط',
    answer: 'ب. صالح',
    image: 'images/Q3.png'
  ),
  QuizQuestion(
    question: 'في أي شهر يصوم المسلمون؟',
    option1: 'أ. شعبان',
    option2: 'ب. شوال',
    option3: 'ج. محرم',
    option4: 'د. رمضان',
    answer: 'د. رمضان',
    image: 'images/Q4.png'
  ),
  QuizQuestion(
    question: 'ما هي السورة التي لا تبدأ بالبسملة؟',
    option1: 'أ. سورة التوبة',
    option2: 'ب. سورة الأنفال',
    option3: 'ج. سورة النمل',
    option4: 'د. سورة هود',
    answer: 'أ. سورة التوبة',
    image: 'images/Q5.png'
  ),
  QuizQuestion(
    question: 'ما اسم السورة التي وردت فيها البسملة مرتين؟',
    option1: 'أ. سورة القصص',
    option2: 'ب. سورة النحل',
    option3: 'ج. سورة النمل',
    option4: 'د. سورة الإسراء',
    answer: 'ج. سورة النمل',
    image: 'images/Q6.png'
  ),
  QuizQuestion(
    question: 'كم سنة لبث أصحاب الكهف في كهفهم كما ذكر القرآن؟',
    option1: 'أ. 100 سنة',
    option2: 'ب. 200 سنة',
    option3: 'ج. 309 سنوات',
    option4: 'د. 500 سنة',
    answer: 'ج. 309 سنوات',
    image: 'images/Q7.png'
  ),
  QuizQuestion(
    question: 'كم عدد سور القرآن الكريم؟',
    option1: 'أ. 110 سور',
    option2: 'ب. 112 سورة',
    option3: 'ج. 113 سورة',
    option4: 'د. 114 سورة',
    answer: 'د. 114 سورة',
    image: 'images/Q8.png'
  ),
  QuizQuestion(
    question: 'ما هي القبلة الأولى للمسلمين؟',
    option1: 'أ. المسجد النبوي',
    option2: 'ب. المسجد الحرام',
    option3: 'ج. المسجد الأقصى',
    option4: 'د. مسجد قباء',
    answer: 'ج. المسجد الأقصى',
    image: 'images/Q9.png'
  ),
  QuizQuestion(
    question: 'ما آخر سورة نزلت كاملة من القرآن الكريم؟',
    option1: 'أ. سورة التوبة',
    option2: 'ب. سورة النصر',
    option3: 'ج. سورة المائدة',
    option4: 'د. سورة الفتح',
    answer: 'ب. سورة النصر', 
    image: 'images/Q10.png'
  ),
  QuizQuestion(
    question: 'كم عدد الملائكة الذين أمدّ الله بهم المسلمين في غزوة بدر وفق سورة الأنفال؟',
    option1: 'أ. 500 ملك',
    option2: 'ب. 700 ملك',
    option3: 'ج. 1000 ملك',
    option4: 'د. 3000 ملك',
    answer: 'ج. 1000 ملك',
    image: 'images/Q11.png'
  ),
  QuizQuestion(
    question: 'من هو الصحابي الذي كان يُعرف بصاحب سر رسول الله ﷺ؟',
    option1: 'أ. أبو عبيدة بن الجراح',
    option2: 'ب. عبد الله بن مسعود',
    option3: 'ج. حذيفة بن اليمان',
    option4: 'د. زيد بن ثابت',
    answer: 'ج. حذيفة بن اليمان',
    image: 'images/Q12.png'
  ),];
  int questionIndex = 0;
  
  int optionIndex = 0;
  
  void checkAnswer({required String selectedOption}) {
  String correctAnswer = quizQuestions[questionIndex].answer;

  if (selectedOption == correctAnswer) {
    answerResults.add(
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Icon(Icons.thumb_up, color: Colors.green),
      ),
    );
  } else {
    answerResults.add(
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: Icon(Icons.thumb_down, color: Colors.redAccent),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final questionFontSize = (screenWidth * 0.045).clamp(14.0, 22.0).toDouble();
    final buttonFontSize = (screenWidth * 0.04).clamp(14.0, 20.0).toDouble();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: answerResults),
          Expanded(
            flex: 6,
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    quizQuestions[questionIndex].image,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.65,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Text(
                    quizQuestions[questionIndex].question,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: questionFontSize),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                 onPressed: () {
    setState(() {
      checkAnswer(
        selectedOption: quizQuestions[questionIndex].option1,
      );

      questionIndex++;
    });
  },
  child: Text(quizQuestions[questionIndex].option1,
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: 
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    checkAnswer(
                      selectedOption: quizQuestions[questionIndex].option2,
                    );
                    questionIndex++;
                  });
                },
                child: Text(
                  quizQuestions[questionIndex].option2,
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    checkAnswer(
                      selectedOption: quizQuestions[questionIndex].option3,
                    );
                    questionIndex++;
                  });
                },
                child: Text(
                  quizQuestions[questionIndex].option3,
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    checkAnswer(
                      selectedOption: quizQuestions[questionIndex].option4,
                    );

                    questionIndex++;
                  });
                },
                child: Text(
                  quizQuestions[questionIndex].option4,
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
