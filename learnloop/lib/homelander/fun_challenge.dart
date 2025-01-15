// //
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:learnloop/our_game/memory_match.dart';
// //
// // import '../our_game/logic_fun.dart';
// // import '../our_game/math_puzzle.dart';
// // import '../our_game/maze_game.dart';
// // import '../our_game/quran_quiz.dart';
// // import '../our_game/sorting_game.dart';
// // import '../our_game/word_game.dart';
// //
// //
// //
// //
// //
// // class FunChallengeScreen extends StatelessWidget {
// //   final List<String> categories = [
// //     'Math Puzzle',
// //     'Word Game',
// //     'Memory Match',
// //     'Quran Quiz',
// //     'Logic Fun',
// //     'Sorting Game',
// //     'Maze Game',
// //     'Brain Boost',
// //     'Shape Sorter',
// //   ];
// //
// //   final List<String> categoryImages = [
// //     'https://example.com/math_puzzle_image.png', // Replace with actual image URLs
// //     'https://example.com/word_game_image.png',
// //     'https://example.com/memory_match_image.png',
// //     'https://example.com/quran_quiz_image.png',
// //     'https://example.com/logic_fun_image.png',
// //     'https://example.com/sorting_game_image.png',
// //     'https://example.com/maze_game_image.png',
// //     'https://example.com/brain_boost_image.png',
// //     'https://example.com/shape_sorter_image.png',
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Choose your challenge!!'),
// //         centerTitle: true,
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             // Total Scoreboard
// //             Container(
// //               margin: EdgeInsets.all(16),
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.teal,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 8,
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     'Total Score',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   Text(
// //                     '1500', // Example score
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // Game Categories as Cards
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Wrap(
// //                 spacing: 8.0, // Horizontal spacing between cards
// //                 runSpacing: 8.0, // Vertical spacing between rows
// //                 children: List.generate(categories.length, (index) {
// //                   return GestureDetector(
// //                     onTap: () {
// //                       handleCategoryTap(context, categories[index]);
// //                     },
// //                     child: Container(
// //                       width: MediaQuery.of(context).size.width / 3 - 16,
// //                       height: 140, // Increased height to fit image and title
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(12),
// //                         gradient: LinearGradient(
// //                           colors: [Colors.teal, Colors.tealAccent],
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                         ),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black12,
// //                             blurRadius: 5,
// //                           ),
// //                         ],
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           Image.network(
// //                             categoryImages[index], // Load image from network
// //                             width: 60, // Adjust width as needed
// //                             height: 60, // Adjust height as needed
// //                             fit: BoxFit.contain,
// //                           ),
// //                           SizedBox(height: 8), // Space between image and title
// //                           Text(
// //                             categories[index],
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 }),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void handleCategoryTap(BuildContext context, String category) {
// //     switch (category) {
// //       case 'Math Puzzle':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => ChallengingMathPuzzleApp()));
// //         break;
// //       case 'Word Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => WordScrambleApp()));
// //         break;
// //       case 'Memory Match':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => const MemoryGame()));
// //         break;
// //       case 'Quran Quiz':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => QuranQuizGame()));
// //         break;
// //       case 'Logic Fun':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => LightsOutGame()));
// //         break;
// //       case 'Sorting Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => GridPuzzleGame()));
// //         break;
// //       case 'Maze Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => const MazeGame()));
// //         break;
// //     }
// //   }
// // }
// //
// //
//
// // import 'package:flutter/material.dart';
// // import 'package:learnloop/our_game/memory_match.dart';
// // import '../our_game/logic_fun.dart';
// // import '../our_game/math_puzzle.dart';
// // import '../our_game/maze_game.dart';
// // import '../our_game/quran_quiz.dart';
// // import '../our_game/sorting_game.dart';
// // import '../our_game/word_game.dart';
// //
// // class FunChallengeScreen extends StatelessWidget {
// //   final List<String> categories = [
// //     'Math Puzzle',
// //     'Word Game',
// //     'Memory Match',
// //     'Quran Quiz',
// //     'Logic Fun',
// //     'Sorting Game',
// //     'Maze Game',
// //     'Brain Boost',
// //     'Shape Sorter',
// //   ];
// //
// //   final List<String> categoryImages = [
// //     'https://cdn.vectorstock.com/i/500p/54/94/text-math-with-formula-border-background-vector-48965494.jpg', // Replace with actual image URLs
// //     'https://example.com/word_game_image.png',
// //     'https://example.com/memory_match_image.png',
// //     'https://example.com/quran_quiz_image.png',
// //     'https://example.com/logic_fun_image.png',
// //     'https://example.com/sorting_game_image.png',
// //     'https://example.com/maze_game_image.png',
// //     'https://example.com/brain_boost_image.png',
// //     'https://example.com/shape_sorter_image.png',
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Choose your challenge!!'),
// //         centerTitle: true,
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             // Total Scoreboard
// //             Container(
// //               margin: EdgeInsets.all(16),
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.teal,
// //                 borderRadius: BorderRadius.circular(12),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 8,
// //                   ),
// //                 ],
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     'Total Score',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   Text(
// //                     '1500', // Example score
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // Game Categories as Cards
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Wrap(
// //                 spacing: 8.0, // Horizontal spacing between cards
// //                 runSpacing: 8.0, // Vertical spacing between rows
// //                 children: List.generate(categories.length, (index) {
// //                   return GestureDetector(
// //                     onTap: () {
// //                       handleCategoryTap(context, categories[index]);
// //                     },
// //                     child: Container(
// //                       width: MediaQuery.of(context).size.width / 3 - 16,
// //                       height: 160, // Adjusted height to accommodate image and title
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(12),
// //                         gradient: LinearGradient(
// //                           colors: [Colors.teal, Colors.tealAccent],
// //                           begin: Alignment.topLeft,
// //                           end: Alignment.bottomRight,
// //                         ),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black12,
// //                             blurRadius: 5,
// //                           ),
// //                         ],
// //                       ),
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           Image.network(
// //                             categoryImages[index], // Load image from network
// //                             width: 80, // Adjust width as needed
// //                             height: 80, // Adjust height as needed
// //                             fit: BoxFit.contain,
// //                           ),
// //                           SizedBox(height: 8), // Space between image and title
// //                           Text(
// //                             categories[index],
// //                             textAlign: TextAlign.center,
// //                             style: TextStyle(
// //                               fontSize: 14,
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 }),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void handleCategoryTap(BuildContext context, String category) {
// //     switch (category) {
// //       case 'Math Puzzle':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => ChallengingMathPuzzleApp()));
// //         break;
// //       case 'Word Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => WordScrambleApp()));
// //         break;
// //       case 'Memory Match':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => const MemoryGame()));
// //         break;
// //       case 'Quran Quiz':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => QuranQuizGame()));
// //         break;
// //       case 'Logic Fun':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => LightsOutGame()));
// //         break;
// //       case 'Sorting Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => GridPuzzleGame()));
// //         break;
// //       case 'Maze Game':
// //         Navigator.push(context,
// //             MaterialPageRoute(builder: (context) => const MazeGame()));
// //         break;
// //     }
// //   }
// // }
// //
//
// import 'package:flutter/material.dart';
//
// import 'our_game/logic_fun.dart';
// import 'our_game/math_puzzle.dart';
// import 'our_game/maze_game.dart';
// import 'our_game/memory_match.dart';
// import 'our_game/quran_quiz.dart';
// import 'our_game/reading_speed.dart';
// import 'our_game/sorting_game.dart';
// import 'our_game/typing_speed.dart';
// import 'our_game/word_game.dart';
//
//
// class FunChallengeScreen extends StatelessWidget {
//   final List<String> categories = [
//     'Math Puzzle',
//     'Word Game',
//     'Memory Match',
//     'Quran Quiz',
//     'Logic Fun',
//     'Sorting Game',
//     'Maze Game',
//     'Speed Reading',
//     'Typing Speed',
//   ];
//
//   final List<String> categoryImages = [
//     'https://cdn.vectorstock.com/i/500p/54/94/text-math-with-formula-border-background-vector-48965494.jpg', // Replace with actual image URLs
//     'https://play-lh.googleusercontent.com/c2Ie9UaD1d9EFi2bdKnFNH8udqXf7aGdlFSmbW_J35JD5eHiQrJTOVpB21FrNzRd6GzL',
//     'https://play-lh.googleusercontent.com/nzLlY6sVzACWwIQSKHLZdp9QY2UIhXUH3K4zzrfs0JG-cfq0xmR51ivmAPcXG26JYw',
//     'https://images.squarespace-cdn.com/content/v1/586d154f03596e5605562ea7/1679947945289-Q4ADX5L0D8V8DI35ILOR/unsplash-image-lKbz2ejxYbA.jpg',
//     'https://img.freepik.com/free-vector/question-mark-sign-brush-stroke-trash-style-typography-vector_53876-140880.jpg',
//     'https://cdn.prod.website-files.com/606a802fcaa89bc357508cad/6123c034286044167618b263_7.png',
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx-nWf3dEekcs5oVthTrDYhqN2H7SDC-ETkg&s',
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlhfSsG4Gbx6UeiWZPMGGfwqKl2X0gb9oJ7Q&s',
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRWay5ASY-sAOhtDUtVhyDuLcvEi36clEX0w&s',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Choose your challenge!!'),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.teal,
//       // ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Total Scoreboard
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 // color: Colors.teal,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               // child: const Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //   children: [
//               //     Text(
//               //       'Total Score',
//               //       style: TextStyle(
//               //         fontSize: 20,
//               //         color: Colors.white,
//               //         fontWeight: FontWeight.bold,
//               //       ),
//               //     ),
//               //     Text(
//               //       '1500', // Example score
//               //       style: TextStyle(
//               //         fontSize: 20,
//               //         color: Colors.white,
//               //         fontWeight: FontWeight.bold,
//               //       ),
//               //     ),
//               //   ],
//               // ),
//             ),
//             // Game Categories as Cards
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Wrap(
//                 spacing: 8.0, // Horizontal spacing between cards
//                 runSpacing: 8.0, // Vertical spacing between rows
//                 children: List.generate(categories.length, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       handleCategoryTap(context, categories[index]);
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3 - 16,
//                       height: 160, // Adjusted height for the whole card
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: const LinearGradient(
//                           colors: [Colors.teal, Colors.tealAccent],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           // Image takes up the full space of the box
//                           Container(
//                             width: double.infinity,
//                             height: 120, // Image takes most of the card
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(categoryImages[index]),
//                                 fit: BoxFit.cover, // Ensure the image covers the box
//                               ),
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(12),
//                                 topRight: Radius.circular(12),
//                               ),
//                             ),
//                           ),
//                           // Title below the box
//                           const SizedBox(height: 8),
//                           Text(
//                             categories[index],
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void handleCategoryTap(BuildContext context, String category) {
//     switch (category) {
//       case 'Math Puzzle':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MathPuzzleGame()));
//         break;
//       case 'Word Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => WordScrambleGame()));
//         break;
//       case 'Memory Match':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const GameBoard()));
//         break;
//       case 'Quran Quiz':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) =>  QuranQuiz()));
//         break;
//       case 'Logic Fun':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => LightsOutGame()));
//         break;
//       case 'Sorting Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => SortingGame()));
//         break;
//       case 'Maze Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MazeGame()));
//         break;
//       case 'Speed Reading':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const SpeedReadingScreen()));
//         break;
//       case 'Typing Speed':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) =>  const TypingSpeedScreen()));
//         break;
//     }
//   }
// }
//

//
//
//
// import 'package:flutter/material.dart';
// import 'package:learnloop/our_game/memory_match.dart';
//
// import '../our_game/logic_fun.dart';
// import '../our_game/math_puzzle.dart';
// import '../our_game/maze_game.dart';
// import '../our_game/quran_quiz.dart';
// import '../our_game/sorting_game.dart';
// import '../our_game/word_game.dart';
//
//
//
//
//
// class FunChallengeScreen extends StatelessWidget {
//   final List<String> categories = [
//     'Math Puzzle',
//     'Word Game',
//     'Memory Match',
//     'Quran Quiz',
//     'Logic Fun',
//     'Sorting Game',
//     'Maze Game',
//     'Brain Boost',
//     'Shape Sorter',
//   ];
//
//   final List<String> categoryImages = [
//     'https://example.com/math_puzzle_image.png', // Replace with actual image URLs
//     'https://example.com/word_game_image.png',
//     'https://example.com/memory_match_image.png',
//     'https://example.com/quran_quiz_image.png',
//     'https://example.com/logic_fun_image.png',
//     'https://example.com/sorting_game_image.png',
//     'https://example.com/maze_game_image.png',
//     'https://example.com/brain_boost_image.png',
//     'https://example.com/shape_sorter_image.png',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose your challenge!!'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Total Scoreboard
//             Container(
//               margin: EdgeInsets.all(16),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.teal,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total Score',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '1500', // Example score
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Game Categories as Cards
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Wrap(
//                 spacing: 8.0, // Horizontal spacing between cards
//                 runSpacing: 8.0, // Vertical spacing between rows
//                 children: List.generate(categories.length, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       handleCategoryTap(context, categories[index]);
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3 - 16,
//                       height: 140, // Increased height to fit image and title
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: LinearGradient(
//                           colors: [Colors.teal, Colors.tealAccent],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.network(
//                             categoryImages[index], // Load image from network
//                             width: 60, // Adjust width as needed
//                             height: 60, // Adjust height as needed
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(height: 8), // Space between image and title
//                           Text(
//                             categories[index],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void handleCategoryTap(BuildContext context, String category) {
//     switch (category) {
//       case 'Math Puzzle':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => ChallengingMathPuzzleApp()));
//         break;
//       case 'Word Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => WordScrambleApp()));
//         break;
//       case 'Memory Match':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MemoryGame()));
//         break;
//       case 'Quran Quiz':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => QuranQuizGame()));
//         break;
//       case 'Logic Fun':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => LightsOutGame()));
//         break;
//       case 'Sorting Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => GridPuzzleGame()));
//         break;
//       case 'Maze Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MazeGame()));
//         break;
//     }
//   }
// }
//
//

// import 'package:flutter/material.dart';
// import 'package:learnloop/our_game/memory_match.dart';
// import '../our_game/logic_fun.dart';
// import '../our_game/math_puzzle.dart';
// import '../our_game/maze_game.dart';
// import '../our_game/quran_quiz.dart';
// import '../our_game/sorting_game.dart';
// import '../our_game/word_game.dart';
//
// class FunChallengeScreen extends StatelessWidget {
//   final List<String> categories = [
//     'Math Puzzle',
//     'Word Game',
//     'Memory Match',
//     'Quran Quiz',
//     'Logic Fun',
//     'Sorting Game',
//     'Maze Game',
//     'Brain Boost',
//     'Shape Sorter',
//   ];
//
//   final List<String> categoryImages = [
//     'https://cdn.vectorstock.com/i/500p/54/94/text-math-with-formula-border-background-vector-48965494.jpg', // Replace with actual image URLs
//     'https://example.com/word_game_image.png',
//     'https://example.com/memory_match_image.png',
//     'https://example.com/quran_quiz_image.png',
//     'https://example.com/logic_fun_image.png',
//     'https://example.com/sorting_game_image.png',
//     'https://example.com/maze_game_image.png',
//     'https://example.com/brain_boost_image.png',
//     'https://example.com/shape_sorter_image.png',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Choose your challenge!!'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Total Scoreboard
//             Container(
//               margin: EdgeInsets.all(16),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.teal,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Total Score',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     '1500', // Example score
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Game Categories as Cards
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Wrap(
//                 spacing: 8.0, // Horizontal spacing between cards
//                 runSpacing: 8.0, // Vertical spacing between rows
//                 children: List.generate(categories.length, (index) {
//                   return GestureDetector(
//                     onTap: () {
//                       handleCategoryTap(context, categories[index]);
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 3 - 16,
//                       height: 160, // Adjusted height to accommodate image and title
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         gradient: LinearGradient(
//                           colors: [Colors.teal, Colors.tealAccent],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Image.network(
//                             categoryImages[index], // Load image from network
//                             width: 80, // Adjust width as needed
//                             height: 80, // Adjust height as needed
//                             fit: BoxFit.contain,
//                           ),
//                           SizedBox(height: 8), // Space between image and title
//                           Text(
//                             categories[index],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void handleCategoryTap(BuildContext context, String category) {
//     switch (category) {
//       case 'Math Puzzle':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => ChallengingMathPuzzleApp()));
//         break;
//       case 'Word Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => WordScrambleApp()));
//         break;
//       case 'Memory Match':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MemoryGame()));
//         break;
//       case 'Quran Quiz':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => QuranQuizGame()));
//         break;
//       case 'Logic Fun':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => LightsOutGame()));
//         break;
//       case 'Sorting Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => GridPuzzleGame()));
//         break;
//       case 'Maze Game':
//         Navigator.push(context,
//             MaterialPageRoute(builder: (context) => const MazeGame()));
//         break;
//     }
//   }
// }
//

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
    'https://cdn.vectorstock.com/i/500p/54/94/text-math-with-formula-border-background-vector-48965494.jpg', // Replace with actual image URLs
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
      // appBar: AppBar(
      //   title: const Text('Choose your challenge!!'),
      //   centerTitle: true,
      //   backgroundColor: Colors.teal,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Scoreboard
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  ),
                ],
              ),
              // child: const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Total Score',
              //       style: TextStyle(
              //         fontSize: 20,
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     Text(
              //       '1500', // Example score
              //       style: TextStyle(
              //         fontSize: 20,
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            // Game Categories as Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0, // Horizontal spacing between cards
                runSpacing: 8.0, // Vertical spacing between rows
                children: List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      handleCategoryTap(context, categories[index]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 16,
                      height: 160, // Adjusted height for the whole card
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
                          // Image takes up the full space of the box
                          Container(
                            width: double.infinity,
                            height: 120, // Image takes most of the card
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(categoryImages[index]),
                                fit: BoxFit.cover, // Ensure the image covers the box
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                          ),
                          // Title below the box
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


