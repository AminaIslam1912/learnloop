import 'package:flutter/material.dart';
import 'dart:async';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  List<String> cardContent = [
    '🐶', '🐶', '🐱', '🐱', '🐼', '🐼',
    '🐸', '🐸', '🦊', '🦊', '🦁', '🦁',
  ];
  List<bool> cardFlipped = [];
  List<bool> cardMatched = [];
  int? firstCardIndex;
  bool canFlip = true;
  int moves = 0;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    cardContent.shuffle();
    cardFlipped = List.filled(cardContent.length, false);
    cardMatched = List.filled(cardContent.length, false);
  }

  void resetGame() {
    setState(() {
      cardContent.shuffle();
      cardFlipped = List.filled(cardContent.length, false);
      cardMatched = List.filled(cardContent.length, false);
      firstCardIndex = null;
      canFlip = true;
      moves = 0;
      matches = 0;
    });
  }

  void onCardTap(int index) {
    if (!canFlip || cardFlipped[index] || cardMatched[index]) return;

    setState(() {
      cardFlipped[index] = true;

      if (firstCardIndex == null) {
        firstCardIndex = index;
      } else {
        moves++;
        canFlip = false;

        if (cardContent[firstCardIndex!] == cardContent[index]) {
          // Match found
          cardMatched[firstCardIndex!] = true;
          cardMatched[index] = true;
          firstCardIndex = null;
          canFlip = true;
          matches++;

          if (matches == cardContent.length ~/ 2) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Congratulations!'),
                content: Text('You won in $moves moves!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            );
          }
        } else {
          // No match
          Timer(const Duration(milliseconds: 1000), () {
            setState(() {
              cardFlipped[firstCardIndex!] = false;
              cardFlipped[index] = false;
              firstCardIndex = null;
              canFlip = true;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,color: Colors.green,),
            onPressed: resetGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Moves: $moves',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: cardContent.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onCardTap(index),
                  child: Card(
                    color: cardMatched[index]
                        ? Colors.green[100]
                        : cardFlipped[index]
                        ? Colors.white
                        : Colors.green,
                    child: Center(
                      child: Text(
                        cardFlipped[index] ? cardContent[index] : '',
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}