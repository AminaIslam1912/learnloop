import 'dart:async';
import 'package:flutter/material.dart';


class TypingSpeedScreen extends StatefulWidget {
  const TypingSpeedScreen({super.key});

  @override
  State<TypingSpeedScreen> createState() => _TypingSpeedScreenState();
}

class _TypingSpeedScreenState extends State<TypingSpeedScreen> {
  final List<String> _sentences = [
    'The quick brown fox jumps over the lazy dog.',
    'From the river to sea, Palestine will be free',
    'Do give feedback our app and encourage others.',
    'Typing speed improves with practice and dedication.',
    'Accuracy is more important than speed in typing.'
  ];

  String _currentSentence = '';
  String _typedSentence = '';
  int _timeLeft = 30;
  int _errors = 0;
  bool _isGameOver = false;
  Timer? _timer;
  int _typedCharacterCount = 0;
  double _wpm = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _currentSentence = _sentences[(DateTime.now().millisecondsSinceEpoch % _sentences.length)];
    _typedSentence = '';
    _typedCharacterCount = 0;
    _errors = 0;
    _timeLeft = 30;
    _isGameOver = false;
    _wpm = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _endGame();
      }
    });
  }

  void _endGame() {
    setState(() {
      _isGameOver = true;
      _timer?.cancel();
      _calculateWpm();
    });
  }

  void _handleTyping(String text) {
    setState(() {
      _typedSentence = text;
      _typedCharacterCount = text.length;
      _errors = 0;

      for (int i = 0; i < text.length; i++) {
        if (i >= _currentSentence.length || text[i] != _currentSentence[i]) {
          _errors++;
        }
      }
    });
  }

  void _calculateWpm() {
    // Words Per Minute calculation
    double secondsTaken = (30 - _timeLeft).toDouble(); // Convert to double
    double minutesTaken = secondsTaken / 60;
    double wpm = (_typedCharacterCount / 5) / minutesTaken;

    setState(() {
      _wpm = wpm;
    });
  }


  void _restartGame() {
    setState(() {
      _isGameOver = false;
      _timeLeft = 30;
      _errors = 0;
      _typedCharacterCount = 0;
      _wpm = 0;
    });
    _startNewGame();
    _startTimer();
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
        title: const Text('Typing Speed Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isGameOver)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time Left: $_timeLeft seconds',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Type this sentence:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentSentence,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    autofocus: true,
                    onChanged: _handleTyping,
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Start typing...',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Errors: $_errors',
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'WPM: ${_wpm.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            if (_isGameOver)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your errors: $_errors',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your WPM: ${_wpm.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text('Restart Game'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
