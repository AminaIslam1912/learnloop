import 'package:flutter/material.dart';

class Question {
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}

class Category {
  final String name;
  final List<Question> questions;

  Category({
    required this.name,
    required this.questions,
  });
}

List<Category> categories = [
  Category(
    name: 'Grammar',
    questions: [
      Question(
        question: 'Which of the following is correct?',
        options: ['I am a student', 'I student am', 'Am a student I'],
        correctOptionIndex: 0,
      ),
      Question(
        question: 'What is the past tense of "go"?',
        options: ['goes', 'went', 'going'],
        correctOptionIndex: 1,
      ),
      Question(
        question: 'Which one is a conjunction?',
        options: ['quickly', 'and', 'blue'],
        correctOptionIndex: 1,
      ),
      Question(
        question: 'Which sentence is in the future tense?',
        options: [
          'I will go to school.',
          'I go to school.',
          'I went to school.'
        ],
        correctOptionIndex: 0,
      ),
      Question(
        question: 'What is the plural of "child"?',
        options: ['childs', 'children', 'childes'],
        correctOptionIndex: 1,
      ),
    ],
  ),
  Category(
    name: 'Vocabulary',
    questions: [
      Question(
        question: 'What is the synonym of "happy"?',
        options: ['sad', 'joyful', 'angry'],
        correctOptionIndex: 1,
      ),
      Question(
        question: 'What is the antonym of "difficult"?',
        options: ['easy', 'hard', 'tough'],
        correctOptionIndex: 0,
      ),
      Question(
        question: 'What does "benevolent" mean?',
        options: ['kind', 'angry', 'selfish'],
        correctOptionIndex: 0,
      ),
      Question(
        question: 'Which word is a noun?',
        options: ['run', 'happy', 'table'],
        correctOptionIndex: 2,
      ),
      Question(
        question: 'What does "abundant" mean?',
        options: ['scarce', 'plentiful', 'invisible'],
        correctOptionIndex: 1,
      ),
    ],
  ),
];

class EnglishQuiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Category')),
      body: GridView.builder(
        padding: const EdgeInsets.only(top: 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.green,
            elevation: 5.0,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(categoryIndex: index),
                  ),
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    categories[index].name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final int categoryIndex;

  const QuizScreen({super.key, required this.categoryIndex});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;
  int currentQuestionIndex = 0;
  bool showAnswer = false;

  void checkAnswer(int selectedIndex) {
    setState(() {
      if (selectedIndex ==
          categories[widget.categoryIndex]
              .questions[currentQuestionIndex]
              .correctOptionIndex) {
        score++;
      } else {
        showAnswer = true;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      showAnswer = false;
      if (currentQuestionIndex <
          categories[widget.categoryIndex].questions.length - 1) {
        currentQuestionIndex++;
      } else {
        _showEndQuizDialog();
      }
    });
  }

  void _showEndQuizDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Finished!'),
          content: Text(
              'Your final score is $score/${categories[widget.categoryIndex].questions.length}'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart Quiz',
                  style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  currentQuestionIndex = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion =
    categories[widget.categoryIndex].questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${categories[widget.categoryIndex].name}'),
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            Align(
              alignment: Alignment.center,
              child: Text(
                'Q${currentQuestionIndex + 1}: ${currentQuestion.question}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < currentQuestion.options.length; i++)
              Center(
                child: ElevatedButton(
                  onPressed: showAnswer ? null : () => checkAnswer(i),
                  child: Text(
                    currentQuestion.options[i],
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (showAnswer)
              Text(
                'Correct Answer: ${currentQuestion.options[currentQuestion.correctOptionIndex]}',
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
            const SizedBox(height: 20),
            Center(child: Text('Score: $score', style: const TextStyle(fontSize: 16))),
            // const Spacer(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestionIndex <
                      categories[widget.categoryIndex].questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}