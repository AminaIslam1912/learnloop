
import 'package:flutter/material.dart';

import 'our_game/code_debugging_quiz.dart';
import 'our_game/dsa_quiz.dart';
import 'our_game/english_quiz.dart';
import 'our_game/math_puzzle.dart';
import 'our_game/memory_match.dart';
import 'our_game/quran_quiz.dart';
import 'our_game/reading_speed.dart';
import 'our_game/sorting_game.dart';
import 'our_game/word_game.dart';


class FunChallengeScreen extends StatelessWidget {
  final List<String> categories = [
    'Math Puzzle',
    'Word Game',
    'Memory Match',
    'Quran Quiz',
    'DSA Quiz',
    'Sorting Game',
    'Debug Code',
    'Speed Reading',
    'English Quiz',
  ];

  final List<String> categoryImages = [
    'https://cdn.vectorstock.com/i/500p/54/94/text-math-with-formula-border-background-vector-48965494.jpg',
    'https://play-lh.googleusercontent.com/c2Ie9UaD1d9EFi2bdKnFNH8udqXf7aGdlFSmbW_J35JD5eHiQrJTOVpB21FrNzRd6GzL',
    'https://play-lh.googleusercontent.com/nzLlY6sVzACWwIQSKHLZdp9QY2UIhXUH3K4zzrfs0JG-cfq0xmR51ivmAPcXG26JYw',
    'https://images.squarespace-cdn.com/content/v1/586d154f03596e5605562ea7/1679947945289-Q4ADX5L0D8V8DI35ILOR/unsplash-image-lKbz2ejxYbA.jpg',
    'https://media.geeksforgeeks.org/wp-content/uploads/20230819113602/dsa-by-sandeep-jain.png',
    'https://cdn.prod.website-files.com/606a802fcaa89bc357508cad/6123c034286044167618b263_7.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlpAFIlYTYnDOqxYKRwQwV2eiUkeQpcVPuqQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlhfSsG4Gbx6UeiWZPMGGfwqKl2X0gb9oJ7Q&s',
    'https://play-lh.googleusercontent.com/eaDUcPNYodG-ea3L_oLHOh0eP-R1xDEI_zTDwI8ZPW47uxq1CGukhKIwy1DS99CGbg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      handleCategoryTap(context, categories[index]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 16,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.green],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(categoryImages[index]),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleCategoryTap(BuildContext context, String category) {
    switch (category) {
      case 'Math Puzzle':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MathPuzzleGame()));
        break;
      case 'Word Game':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WordScrambleGame()));
        break;
      case 'Memory Match':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GameBoard()));
        break;
      case 'Quran Quiz':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  QuranQuiz()));
        break;
      case 'DSA Quiz':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DsaQuiz()));
        break;
      case 'Sorting Game':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SortingGame()));
        break;
      case 'Debug Code':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CodeDebuggingQuiz()));
        break;
      case 'Speed Reading':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SpeedReadingScreen()));
        break;
      case 'English Quiz':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>   EnglishQuiz()));
        break;
    }
  }
}


