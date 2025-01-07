import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(QuizTimeGame());

class QuizTimeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Paris', 'London', 'Berlin', 'Madrid'],
      'answer': 'Paris',
    },
    {
      'question': 'What is 5 + 3?',
      'options': ['5', '8', '10', '7'],
      'answer': '8',
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': [
        'William Shakespeare',
        'Charles Dickens',
        'Jane Austen',
        'Mark Twain'
      ],
      'answer': 'William Shakespeare',
    },
    {
      'question': 'What is the largest planet in our Solar System?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
      'answer': 'Jupiter',
    },
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String _selectedOption = '';
  Timer? _timer;
  int _timeRemaining = 10;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timeRemaining = 10;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer?.cancel();
          _moveToNextQuestion();
        }
      });
    });
  }

  void _checkAnswer(String selectedOption) {
    setState(() {
      _isAnswered = true;
      _selectedOption = selectedOption;
      if (selectedOption == _questions[_currentQuestionIndex]['answer']) {
        _score++;
      }
    });
    Future.delayed(Duration(seconds: 2), _moveToNextQuestion);
  }

  void _moveToNextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOption = '';
        _startTimer();
      } else {
        _timer?.cancel();
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Quiz Over!'),
        content: Text('Your Score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartQuiz();
            },
            child: Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isAnswered = false;
      _selectedOption = '';
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Time'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} / ${_questions.length}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ..._questions[_currentQuestionIndex]['options']
                .map<Widget>((option) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnswered
                    ? (option == _questions[_currentQuestionIndex]['answer']
                    ? Colors.green
                    : (option == _selectedOption
                    ? Colors.red
                    : Colors.grey))
                    : Colors.teal,
              ),
              onPressed: _isAnswered
                  ? null
                  : () => _checkAnswer(option),
              child: Text(option),
            ))
                .toList(),
            SizedBox(height: 20),
            Text(
              'Time Remaining: $_timeRemaining seconds',
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
