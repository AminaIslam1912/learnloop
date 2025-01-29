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
        int num3 = random.nextInt(50) + 1;
        operator = '*';
        correctAnswer = (num1 + num2) * num3;
      } else {
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
            num1 = correctAnswer * num2;
            break;
        }
      }
      timerCount = isHardMode ? 5 : 10;
    });
  }


  void checkAnswer() {
    if (answerController.text.isEmpty) return;

    int userAnswer = int.tryParse(answerController.text) ?? -1;

    if (userAnswer == correctAnswer) {
      setState(() {
        score += 10 ;
        streak++;
        feedbackMessage = 'Correct! 🎉';
        generateProblem();
        answerController.clear();
      });
    } else {
      setState(() {
        streak = 0;
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
      score = 0;
      streak = 0;
      generateProblem();
    });
  }

  void resetGame() {
    setState(() {
      leaderboard = leaderboard.take(5).toList();
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
        backgroundColor: isHardMode ? Colors.black : Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.green),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: toggleDifficulty,
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    isHardMode ? 'Switch to Easy Mode' : 'Switch to Hard Mode',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 30),
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
              cursorColor: Colors.green,

              decoration: InputDecoration(
                labelText: "Enter your answer",
                labelStyle: const TextStyle(
                  color: Colors.green,
                ),


                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: checkAnswer,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),


            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
