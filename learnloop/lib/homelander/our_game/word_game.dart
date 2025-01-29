
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class WordScrambleGame extends StatefulWidget {
  const WordScrambleGame({super.key});

  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame> {
  final List<String> easyWords = [
    'apple', 'chair', 'table', 'bread', 'plant', 'python', 'phone', 'free', 'mother', 'father'
  ];
  final List<String> mediumWords = [
    'puzzle', 'garden', 'butter', 'orange', 'purple', 'brother', 'sister', 'date', 'desert', 'life'
  ];
  final List<String> hardWords = [
    'elephant', 'scramble', 'airplane', 'sunflower', 'computer', 'examination', 'palestine', 'bangladesh', 'bicycle'
  ];

  late String scrambledWord;
  late String correctWord;
  String feedbackMessage = '';
  int score = 0;
  int timerCount = 15;
  String selectedDifficulty = 'Easy';
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
      List<String> wordList;
      if (selectedDifficulty == 'Easy') {
        wordList = easyWords;
      } else if (selectedDifficulty == 'Medium') {
        wordList = mediumWords;
      } else {
        wordList = hardWords;
      }
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
        score += selectedDifficulty == 'Hard' ? 20 : (selectedDifficulty == 'Medium' ? 15 : 10);
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

  void resetGame() {
    setState(() {
      score = 0;
      feedbackMessage = 'Game Reset! Start Again.';
      generateWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Scramble'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.green,),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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

              // Card(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   elevation: 5,
              //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: [
              //         const Text(
              //           'Select Difficulty: ',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.green,
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //         Container(
              //           padding: const EdgeInsets.symmetric(horizontal: 12),
              //           decoration: BoxDecoration(
              //             color: Colors.black,
              //             borderRadius: BorderRadius.circular(8),
              //             border: Border.all(color: Colors.green, width: 1.5),
              //           ),
              //           child: DropdownButton<String>(
              //             value: selectedDifficulty,
              //             icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
              //             dropdownColor: Colors.black,
              //             borderRadius: BorderRadius.circular(8),
              //             style: const TextStyle(fontSize: 16, color: Colors.green,fontWeight: FontWeight.bold),
              //             underline: Container(), // Remove default underline
              //             items: ['Easy', 'Medium', 'Hard'].map((String difficulty) {
              //               return DropdownMenuItem<String>(
              //                 value: difficulty,
              //                 child: Text(
              //                   difficulty,
              //                   style: const TextStyle(fontSize: 16),
              //                 ),
              //               );
              //             }).toList(),
              //             onChanged: (String? newValue) {
              //               setState(() {
              //                 selectedDifficulty = newValue!;
              //                 resetGame();
              //               });
              //             },
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Card(
                color: Colors.black, // Set background color to black

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,

                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Ensures space between items
                    children: [
                      const Text(
                        'Select Difficulty: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded( // Wraps the DropdownButton in Expanded to allow flexible space usage
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                           // border: Border.all(color: Colors.green, width: 1.5),
                          ),
                          child: DropdownButton<String>(
                            value: selectedDifficulty,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                            dropdownColor: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                            underline: Container(), // Remove default underline
                            items: ['Easy', 'Medium', 'Hard'].map((String difficulty) {
                              return DropdownMenuItem<String>(
                                value: difficulty,
                                child: Text(
                                  difficulty,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDifficulty = newValue!;
                                resetGame();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 20),
              // Answer Input
              // TextField(
              //   controller: answerController,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     hintText: 'Enter your answer here',
              //   ),
              // ),
              TextField(
                controller: answerController,
              //  keyboardType: TextInputType.number,
                cursorColor: Colors.green, // Set cursor color to green

                decoration: InputDecoration(
                  labelText: "Enter your answer",
                  labelStyle: const TextStyle(
                    color: Colors.green, // Green label text
                  ),


                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    borderSide: const BorderSide(
                      color: Colors.green, // Green border on focus
                      width: 2.0, // Thickness of the border
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              // Submit Button
              // ElevatedButton(
              //   onPressed: checkAnswer,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.teal,
              //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //   ),
              //   child: const Text(
              //     'Submit',
              //     style: TextStyle(fontSize: 18, color: Colors.white),
              //   ),
              // ),
              //

              OutlinedButton(
                onPressed: checkAnswer,
                style: OutlinedButton.styleFrom(
                  //padding: const EdgeInsets.all(20), // Square shape with equal padding
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Rectangular shape with more width
                  //  side: const BorderSide(color: Colors.green, width: 2), // Green border
                  backgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)), // Slightly rounded corners
                  ),
                ),

                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold), // Green text
                ),
              ),


              const SizedBox(height: 20),
              // Feedback Message
              Text(
                feedbackMessage,
                style: TextStyle(
                  fontSize: 18,
                  color: feedbackMessage.contains('Correct') ? Colors.green : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
