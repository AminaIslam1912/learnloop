import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MathPuzzleGame extends StatefulWidget {
  const MathPuzzleGame({super.key});

  @override
  State<MathPuzzleGame> createState() => _MathPuzzleGameState();
}

class _MathPuzzleGameState extends State<MathPuzzleGame> {
  int num1 = 0, num2 = 0, correctAnswer = 0, score = 0, streak = 0, timerCount = 10;
  String operator = '';
  bool isHardMode = false;
  Timer? timer;
  final Random random = Random();
  TextEditingController answerController = TextEditingController();
  String feedbackMessage = '';
  List<String> leaderboard = [];

  @override
  void initState() {
    super.initState();
    generateProblem();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void generateProblem() {
    setState(() {
      num1 = random.nextInt(isHardMode ? 100 : 20) + 1;
      num2 = random.nextInt(isHardMode ? 100 : 20) + 1;

      if (isHardMode && random.nextBool()) {
        // Introduce complex operations
        int num3 = random.nextInt(50) + 1;
        operator = '*';
        correctAnswer = (num1 + num2) * num3;
      } else {
        // Basic operations
        int op = random.nextInt(4);
        switch (op) {
          case 0:
            operator = '+';
            correctAnswer = num1 + num2;
            break;
          case 1:
            operator = '-';
            correctAnswer = num1 - num2;
            break;
          case 2:
            operator = '*';
            correctAnswer = num1 * num2;
            break;
          case 3:
            operator = '/';
            correctAnswer = (num1 / num2).floor();
            num1 = correctAnswer * num2; // Clean division
            break;
        }
      }
      timerCount = isHardMode ? 5 : 10; // Adjust timer for hard mode
    });
  }


  void checkAnswer() {
    if (answerController.text.isEmpty) return;

    int userAnswer = int.tryParse(answerController.text) ?? -1;

    if (userAnswer == correctAnswer) {
      setState(() {
        score += 10 ; // Bonus for streak
        streak++;
        feedbackMessage = 'Correct! 🎉';
        generateProblem();
        answerController.clear();
      });
    } else {
      setState(() {
        streak = 0; // Reset streak
        feedbackMessage = 'Wrong Answer. Try again! 😞';
      });
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerCount > 0) {
          timerCount--;
        } else {
          streak = 0;
          feedbackMessage = 'Time Up! 😢';
          generateProblem();
        }
      });
    });
  }

  void toggleDifficulty() {
    setState(() {
      isHardMode = !isHardMode;
      feedbackMessage = isHardMode ? 'Hard Mode Activated!' : 'Easy Mode Activated!';
      score = 0; // Reset score for fairness
      streak = 0;
      generateProblem();
    });
  }

  void resetGame() {
    setState(() {
      //leaderboard.add('Score: $score (Streak: $streak)');
      leaderboard = leaderboard.take(5).toList(); // Keep top 5 scores
      score = 0;
      streak = 0;
      feedbackMessage = 'Game Reset! Start Again.';
      generateProblem();
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
        title: const Text('Math Puzzle'),
        backgroundColor: isHardMode ? Colors.green : Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
          ),
          // IconButton(
          //   icon: Icon(Icons.exit_to_app),
          //   onPressed: quitGame,
          // ),
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
            // Problem Display
            Text(
              'Solve: $num1 $operator $num2 = ?',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Answer Input
            TextField(
              controller: answerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your answer',
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
                color: feedbackMessage.contains('Correct')
                    ? Colors.green
                    : Colors.red,
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
            const SizedBox(height: 20),
            // Leaderboard
            // const Text(
            //   'Leaderboard',
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            for (String scoreEntry in leaderboard)
              Text(
                scoreEntry,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
