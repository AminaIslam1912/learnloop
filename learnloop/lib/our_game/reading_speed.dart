import 'package:flutter/material.dart';
import 'dart:async';

class SpeedReadingScreen extends StatefulWidget {
  const SpeedReadingScreen({super.key});

  @override
  State<SpeedReadingScreen> createState() => _SpeedReadingScreenState();
}

class _SpeedReadingScreenState extends State<SpeedReadingScreen> {
  final TextEditingController _answerController = TextEditingController();
  final List<Map<String, String>> _passages = [
    {
      'text': 'The quick brown fox jumps over the lazy dog.',
      'question': 'What animal jumps over the dog?',
      'answer': 'fox',
    },
    {
      'text': 'Flutter is an open-source UI software development kit created by Google.',
      'question': 'Who created Flutter?',
      'answer': 'Google',
    },
    {
      'text': 'Speed reading is a technique to read faster while improving comprehension.',
      'question': 'What is speed reading?',
      'answer': 'a technique to read faster while improving comprehension',
    },
  ];
  int _currentIndex = 0;
  int _timeLeft = 10;
  bool _isReading = true;
  bool _isAnswered = false;
  bool _isCorrect = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endReading();
      }
    });
  }

  void _endReading() {
    setState(() {
      _isReading = false;
    });
  }

  void _checkAnswer() {
    setState(() {
      if (_answerController.text.trim().toLowerCase() ==
          _passages[_currentIndex]['answer']!.toLowerCase()) {
        _isCorrect = true;
      } else {
        _isCorrect = false;
      }
      _isAnswered = true;
    });
  }

  void _nextPassage() {
    setState(() {
      if (_currentIndex < _passages.length - 1) {
        _currentIndex++;
        _isReading = true;
        _isAnswered = false;
        _isCorrect = false;
        _timeLeft = 10;
        _answerController.clear();
      } else {
        // End of game, show final score
        _showEndGameDialog();
      }
    });
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('You completed all passages!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentIndex = 0;
                  _isReading = true;
                  _isAnswered = false;
                  _isCorrect = false;
                  _timeLeft = 10;
                  _answerController.clear();
                });
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Reading Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Left: $_timeLeft seconds',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_isReading) ...[
              const Text(
                'Passage:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _passages[_currentIndex]['text']!,
                style: const TextStyle(fontSize: 18),
              ),
            ] else ...[
              const Text(
                'Comprehension Question:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _passages[_currentIndex]['question']!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Your Answer',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('Submit Answer'),
              ),
              if (_isAnswered) ...[
                const SizedBox(height: 10),
                Text(
                  _isCorrect ? 'Correct!' : 'Incorrect. Try Again.',
                  style: TextStyle(
                    color: _isCorrect ? Colors.green : Colors.red,
                    fontSize: 18,
                  ),
                ),
              ],
            ],
            if (!_isReading)
              ElevatedButton(
                onPressed: _nextPassage,
                child: const Text('Next Passage'),
              ),
          ],
        ),
      ),
    );
  }
}
