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
