import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';



class WordScrambleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WordScrambleGame(),
    );
  }
}

class WordScrambleGame extends StatefulWidget {
  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame> {
  final List<String> easyWords = ['apple', 'chair', 'table', 'bread', 'plant'];
  final List<String> mediumWords = ['puzzle', 'garden', 'butter', 'orange', 'purple'];
  final List<String> hardWords = ['elephant', 'scramble', 'airplane', 'sunflower', 'computer'];

  late String scrambledWord;
  late String correctWord;
  String feedbackMessage = '';
  int score = 0;
  int timerCount = 15;
  bool isHardMode = false;
  Timer? timer;
  final TextEditingController answerController = TextEditingController();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    generateWord();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void generateWord() {
    setState(() {
      List<String> wordList = isHardMode
          ? hardWords
          : (score > 50 ? mediumWords : easyWords); // Transition difficulty with score.
      correctWord = wordList[random.nextInt(wordList.length)];
      scrambledWord = scrambleWord(correctWord);
      timerCount = 15; // Reset timer.
    });
  }

  String scrambleWord(String word) {
    List<String> chars = word.split('');
    chars.shuffle();
    return chars.join('');
  }

  void checkAnswer() {
    if (answerController.text.isEmpty) return;

    String userAnswer = answerController.text.toLowerCase();

    if (userAnswer == correctWord) {
      setState(() {
        score += isHardMode ? 20 : 10;
        feedbackMessage = 'Correct! 🎉';
        generateWord();
        answerController.clear();
      });
    } else {
      setState(() {
        feedbackMessage = 'Wrong! The correct word was "$correctWord".';
        generateWord();
        answerController.clear();
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerCount > 0) {
          timerCount--;
        } else {
          feedbackMessage = 'Time Up! The correct word was "$correctWord".';
          generateWord();
        }
      });
    });
  }

  void toggleDifficulty() {
    setState(() {
      isHardMode = !isHardMode;
      feedbackMessage = isHardMode ? 'Hard Mode Activated!' : 'Easy Mode Activated!';
      score = 0;
      generateWord();
    });
  }

  void resetGame() {
    setState(() {
      score = 0;
      feedbackMessage = 'Game Reset! Start Again.';
      generateWord();
    });
  }

  void quitGame() {
    timer?.cancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Scramble Game'),
        backgroundColor: isHardMode ? Colors.red : Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scoreboard and Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time: $timerCount',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display Scrambled Word
            const Text(
              'Unscramble the word:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              scrambledWord,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Answer Input
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer here',
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Feedback Message
            Text(
              feedbackMessage,
              style: TextStyle(
                fontSize: 18,
                color: feedbackMessage.contains('Correct') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Toggle Difficulty
            ElevatedButton(
              onPressed: toggleDifficulty,
              style: ElevatedButton.styleFrom(
                backgroundColor: isHardMode ? Colors.red : Colors.green,
              ),
              child: Text(
                isHardMode ? 'Switch to Easy Mode' : 'Switch to Hard Mode',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
