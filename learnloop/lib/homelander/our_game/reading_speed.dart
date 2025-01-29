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
    {
      'text': 'Albert Einstein developed the theory of relativity.',
      'question': 'Who developed the theory of relativity?',
      'answer': 'Albert Einstein',
    },
    {
      'text': 'The Great Wall of China is one of the seven wonders of the world.',
      'question': 'Which country is home to the Great Wall?',
      'answer': 'China',
    },
    {
      'text': 'Photosynthesis is the process by which plants make their food.',
      'question': 'What process do plants use to make their food?',
      'answer': 'photosynthesis',
    },
    {
      'text': 'Mount Everest is the highest mountain in the world.',
      'question': 'What is the highest mountain in the world?',
      'answer': 'Mount Everest',
    },
    {
      'text': 'Neil Armstrong was the first person to walk on the moon.',
      'question': 'Who was the first person to walk on the moon?',
      'answer': 'Neil Armstrong',
    },
    {
      'text': 'Water boils at 100 degrees Celsius at sea level.',
      'question': 'At what temperature does water boil at sea level?',
      'answer': '100 degrees Celsius',
    },
    {
      'text': 'The Amazon rainforest is often called the lungs of the Earth.',
      'question': 'What is the Amazon rainforest often called?',
      'answer': 'the lungs of the Earth',
    },
    {
      'text': 'Shakespeare wrote the play Romeo and Juliet.',
      'question': 'Who wrote Romeo and Juliet?',
      'answer': 'Shakespeare',
    },
    {
      'text': 'The Pacific Ocean is the largest ocean on Earth.',
      'question': 'What is the largest ocean on Earth?',
      'answer': 'Pacific Ocean',
    },
    {
      'text': 'Electricity is measured in units called watts.',
      'question': 'In what units is electricity measured?',
      'answer': 'watts',
    },
    {
      'text': 'The Eiffel Tower is located in Paris, France.',
      'question': 'In which city is the Eiffel Tower located?',
      'answer': 'Paris',
    },
    {
      'text': 'A leap year occurs every four years.',
      'question': 'How often does a leap year occur?',
      'answer': 'every four years',
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
        _showEndGameDialog();
      }
    });
  }

  void _showEndGameDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over', style: TextStyle(color: Colors.red),),
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
              child: Text('Restart', style: TextStyle(color: Colors.green)),
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
        title: const Text(
          'Speed Reading Challenge',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Time Left: $_timeLeft seconds',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.red
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isReading) ...[
              const Text(
                'Passage:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  _passages[_currentIndex]['text']!,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                ),
              ),
            ] else ...[
              const Text(
                'Comprehension Question:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _passages[_currentIndex]['question']!,
                style: const TextStyle(fontSize: 18, height: 1.5),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Your Answer',

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.green, width: 3),
                  ),



                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Answer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              if (_isAnswered) ...[
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    _isCorrect ? 'Correct!' : 'Incorrect. Try Again.',
                    style: TextStyle(
                      color: _isCorrect ? Colors.green : Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
            SizedBox(height: 20,),
            if (!_isReading)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _nextPassage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next Passage',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }



}
