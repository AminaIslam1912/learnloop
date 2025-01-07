// import 'dart:math';
// import 'package:flutter/material.dart';
//
//
// class QuranQuizGame extends StatelessWidget {
//   const QuranQuizGame({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: QuizSelectionScreen(),
//     );
//   }
// }
//
// class QuizSelectionScreen extends StatelessWidget {
//   final List<String> categories = [
//     'General Quran Quiz',
//     'Prophet Stories Quiz',
//     'Surahs and Verses Quiz',
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Quran Quiz Game'),
//         backgroundColor: Colors.green,
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(categories[index]),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => QuranQuizScreen(
//                       category: categories[index],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class QuranQuizScreen extends StatefulWidget {
//   final String category;
//
//   QuranQuizScreen({required this.category});
//
//   @override
//   State<QuranQuizScreen> createState() => _QuranQuizScreenState();
// }
//
// class _QuranQuizScreenState extends State<QuranQuizScreen> {
//   int _currentQuestionIndex = 0;
//   int _score = 0;
//   late List<Map<String, dynamic>> questionPool;
//   final Random _random = Random();
//
//   @override
//   void initState() {
//     super.initState();
//     _generateQuestions();
//   }
//
//   void _generateQuestions() {
//     // Larger pool of questions (50+ questions per category)
//     final allQuestions = {
//       'General Quran Quiz': [
//         {
//           'question': 'Which Surah is known as the "Heart of the Quran"?',
//           'options': ['Surah Al-Fatiha', 'Surah Yasin', 'Surah Al-Baqarah', 'Surah Al-Ikhlas'],
//           'answer': 'Surah Yasin',
//         },
//         {
//           'question': 'How many Surahs are in the Quran?',
//           'options': ['114', '100', '120', '130'],
//           'answer': '114',
//         },
//         {
//           'question': 'Who is the last Prophet mentioned in the Quran?',
//           'options': ['Prophet Musa', 'Prophet Ibrahim', 'Prophet Muhammad (PBUH)', 'Prophet Isa'],
//           'answer': 'Prophet Muhammad (PBUH)',
//         },
//         {
//           'question': 'In which Surah is the verse "Ayat al-Kursi" found?',
//           'options': ['Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah Al-Araf', 'Surah An-Nisa'],
//           'answer': 'Surah Al-Baqarah',
//         },
//         {
//           'question': 'Which Surah is the longest in the Quran?',
//           'options': ['Surah Al-Araf', 'Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Al-Fatiha'],
//           'answer': 'Surah Al-Baqarah',
//         },
//         // Add more questions here (up to 50+)
//       ],
//       'Prophet Stories Quiz': [
//         {
//           'question': 'Which Prophet was known for building the Ark?',
//           'options': ['Prophet Nuh', 'Prophet Ibrahim', 'Prophet Musa', 'Prophet Yunus'],
//           'answer': 'Prophet Nuh',
//         },
//         {
//           'question': 'Which Prophet was swallowed by a big fish?',
//           'options': ['Prophet Nuh', 'Prophet Yunus', 'Prophet Musa', 'Prophet Isa'],
//           'answer': 'Prophet Yunus',
//         },
//         {
//           'question': 'Which Prophet is known for his wisdom and judgment?',
//           'options': ['Prophet Musa', 'Prophet Sulaiman', 'Prophet Ibrahim', 'Prophet Muhammad (PBUH)'],
//           'answer': 'Prophet Sulaiman',
//         },
//         {
//           'question': 'Which Prophet was the son of Prophet Ibrahim?',
//           'options': ['Prophet Ishaq', 'Prophet Musa', 'Prophet Muhammad', 'Prophet Yusuf'],
//           'answer': 'Prophet Ishaq',
//         },
//         // Add more questions here (up to 50+)
//       ],
//       'Surahs and Verses Quiz': [
//         {
//           'question': 'In which Surah is the verse "Bismillah ir-Rahman ir-Rahim" found?',
//           'options': ['Surah Al-Fatiha', 'Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah An-Nisa'],
//           'answer': 'Surah Al-Fatiha',
//         },
//         {
//           'question': 'Which Surah has the verse "La ilaha illallah"?',
//           'options': ['Surah Al-Ikhlas', 'Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Al-Ahzab'],
//           'answer': 'Surah Al-Ikhlas',
//         },
//         {
//           'question': 'Which Surah mentions the verse "Wa Iza jaa’a nasru Allahi wal-fatih"',
//           'options': ['Surah Al-Fath', 'Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah Al-Araf'],
//           'answer': 'Surah Al-Fath',
//         },
//         {
//           'question': 'Which Surah is called the "Mother of the Book"?',
//           'options': ['Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah Al-Ahzab', 'Surah Al-Ikhlas'],
//           'answer': 'Surah Al-Fatiha',
//         },
//         // Add more questions here (up to 50+)
//       ],
//     };
//
//     // Select the correct category's question pool
//     questionPool = allQuestions[widget.category] ?? [];
//
//     // Shuffle the questions to make each game unique
//     questionPool.shuffle();
//   }
//
//   void _checkAnswer(String selectedAnswer) {
//     if (questionPool[_currentQuestionIndex]['answer'] == selectedAnswer) {
//       setState(() {
//         _score++;
//       });
//     }
//     _nextQuestion();
//   }
//
//   void _nextQuestion() {
//     if (_currentQuestionIndex < questionPool.length - 1) {
//       setState(() {
//         _currentQuestionIndex++;
//       });
//     } else {
//       _showFinalScore();
//     }
//   }
//
//   void _showFinalScore() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Quiz Completed!'),
//         content: Text('Your final score is: $_score/${questionPool.length}'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _score = 0;
//                 _currentQuestionIndex = 0;
//               });
//               Navigator.of(context).pop();
//             },
//             child: const Text('Restart'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.category),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Question ${_currentQuestionIndex + 1}/${questionPool.length}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               questionPool[_currentQuestionIndex]['question'],
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             Column(
//               children: (questionPool[_currentQuestionIndex]['options'] as List<String>)
//                   .map((option) => ElevatedButton(
//                 onPressed: () {
//                   _checkAnswer(option);
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor:  Colors.green),
//                 child: Text(option),
//               ))
//                   .toList(),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               'Current Score: $_score',
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';

class QuranQuizGame extends StatelessWidget {
  const QuranQuizGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizSelectionScreen(),
    );
  }
}

class QuizSelectionScreen extends StatelessWidget {
  final List<String> categories = [
    'General Quran Quiz',
    'Prophet Stories Quiz',
    'Surahs and Verses Quiz',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Quiz Game'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              title: Text(categories[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuranQuizScreen(
                      category: categories[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class QuranQuizScreen extends StatefulWidget {
  final String category;

  QuranQuizScreen({required this.category});

  @override
  State<QuranQuizScreen> createState() => _QuranQuizScreenState();
}

class _QuranQuizScreenState extends State<QuranQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  late List<Map<String, dynamic>> questionPool;
  final Random _random = Random();
  String? _selectedAnswer;
  bool _isAnswerCorrect = true;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    final allQuestions = {
      'General Quran Quiz': [
        {
          'question': 'Which Surah is known as the "Heart of the Quran"?',
          'options': ['Surah Al-Fatiha', 'Surah Yasin', 'Surah Al-Baqarah', 'Surah Al-Ikhlas'],
          'answer': 'Surah Yasin',
        },
        {
          'question': 'How many Surahs are in the Quran?',
          'options': ['114', '100', '120', '130'],
          'answer': '114',
        },
        {
          'question': 'Who is the last Prophet mentioned in the Quran?',
          'options': ['Prophet Musa', 'Prophet Ibrahim', 'Prophet Muhammad (PBUH)', 'Prophet Isa'],
          'answer': 'Prophet Muhammad (PBUH)',
        },
        {
          'question': 'In which Surah is the verse "Ayat al-Kursi" found?',
          'options': ['Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah Al-Araf', 'Surah An-Nisa'],
          'answer': 'Surah Al-Baqarah',
        },
        {
          'question': 'Which Surah is the longest in the Quran?',
          'options': ['Surah Al-Araf', 'Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Al-Fatiha'],
          'answer': 'Surah Al-Baqarah',
        },
        {
          'question': 'Which Surah is known as the "Verse of the Throne"?',
          'options': ['Surah Al-Baqarah', 'Surah Al-Imran', 'Surah An-Nisa', 'Surah Al-Fatiha'],
          'answer': 'Surah Al-Baqarah',
        },
        {
          'question': 'Who was the first person to accept Islam?',
          'options': ['Abu Bakr', 'Ali ibn Abi Talib', 'Khadijah', 'Umar ibn al-Khattab'],
          'answer': 'Khadijah',
        },
        {
          'question': 'In which Surah is the verse "La ikraha fid-deen" found?',
          'options': ['Surah Al-Baqarah', 'Surah Al-Anfal', 'Surah Al-Imran', 'Surah At-Tawbah'],
          'answer': 'Surah Al-Baqarah',
        },
        {
          'question': 'What was the name of Prophet Muhammad (PBUH) father?',
          'options': ['Abu Talib', 'Abu Bakr', 'Abdullah', 'Uthman'],
          'answer': 'Abdullah',
        },
        {
          'question': 'What is the meaning of the word "Quran"?',
          'options': ['The Book', 'The Recitation', 'The Revelation', 'The Word'],
          'answer': 'The Recitation',
        },
      ],
      'Prophet Stories Quiz': [
        {
          'question': 'Which Prophet was known for building the Ark?',
          'options': ['Prophet Nuh', 'Prophet Ibrahim', 'Prophet Musa', 'Prophet Yunus'],
          'answer': 'Prophet Nuh',
        },
        {
          'question': 'Which Prophet was swallowed by a big fish?',
          'options': ['Prophet Nuh', 'Prophet Yunus', 'Prophet Musa', 'Prophet Isa'],
          'answer': 'Prophet Yunus',
        },
        {
          'question': 'Which Prophet is known for his wisdom and judgment?',
          'options': ['Prophet Musa', 'Prophet Sulaiman', 'Prophet Ibrahim', 'Prophet Muhammad (PBUH)'],
          'answer': 'Prophet Sulaiman',
        },
        {
          'question': 'Which Prophet was the son of Prophet Ibrahim?',
          'options': ['Prophet Ishaq', 'Prophet Musa', 'Prophet Muhammad', 'Prophet Yusuf'],
          'answer': 'Prophet Ishaq',
        },
        {
          'question': 'Which Prophet parted the Red Sea?',
          'options': ['Prophet Nuh', 'Prophet Musa', 'Prophet Ibrahim', 'Prophet Isa'],
          'answer': 'Prophet Musa',
        },
        {
          'question': 'Which Prophet was thrown into the fire by his people?',
          'options': ['Prophet Ibrahim', 'Prophet Yunus', 'Prophet Musa', 'Prophet Isa'],
          'answer': 'Prophet Ibrahim',
        },
        {
          'question': 'Which Prophet was the last to receive revelation?',
          'options': ['Prophet Ibrahim', 'Prophet Musa', 'Prophet Muhammad (PBUH)', 'Prophet Isa'],
          'answer': 'Prophet Muhammad (PBUH)',
        },
        {
          'question': 'Which Prophet was known for his patience and tested by many calamities?',
          'options': ['Prophet Ayyub', 'Prophet Ibrahim', 'Prophet Yunus', 'Prophet Yusuf'],
          'answer': 'Prophet Ayyub',
        },
        {
          'question': 'Which Prophet was given the book of Psalms?',
          'options': ['Prophet Dawud', 'Prophet Musa', 'Prophet Ibrahim', 'Prophet Isa'],
          'answer': 'Prophet Dawud',
        },
        {
          'question': 'Which Prophet was taken up to the heavens?',
          'options': ['Prophet Isa', 'Prophet Muhammad (PBUH)', 'Prophet Musa', 'Prophet Yunus'],
          'answer': 'Prophet Isa',
        },
      ],
      'Surahs and Verses Quiz': [
        {
          'question': 'In which Surah is the verse "Bismillah ir-Rahman ir-Rahim" found?',
          'options': ['Surah Al-Fatiha', 'Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah An-Nisa'],
          'answer': 'Surah Al-Fatiha',
        },
        {
          'question': 'Which Surah has the verse "La ilaha illallah"?',
          'options': ['Surah Al-Ikhlas', 'Surah Al-Baqarah', 'Surah An-Nisa', 'Surah Al-Ahzab'],
          'answer': 'Surah Al-Ikhlas',
        },
        {
          'question': 'Which Surah mentions the verse "Wa Iza jaa’a nasru Allahi wal-fatih"',
          'options': ['Surah Al-Fath', 'Surah Al-Baqarah', 'Surah Al-Ikhlas', 'Surah Al-Araf'],
          'answer': 'Surah Al-Fath',
        },
        {
          'question': 'Which Surah is called the "Mother of the Book"?',
          'options': ['Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah Al-Ahzab', 'Surah Al-Ikhlas'],
          'answer': 'Surah Al-Fatiha',
        },
        {
          'question': 'In which Surah is the verse "Wa qul jaa’a haqq wa zahaq al-batil"?',
          'options': ['Surah Al-Isra', 'Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah At-Tawbah'],
          'answer': 'Surah Al-Isra',
        },
        {
          'question': 'In which Surah does the verse "Inna ma’al usri yusra" appear?',
          'options': ['Surah Al-Baqarah', 'Surah Ash-Sharh', 'Surah Al-Ankabut', 'Surah At-Tawbah'],
          'answer': 'Surah Ash-Sharh',
        },
        {
          'question': 'Which Surah contains the longest verse in the Quran?',
          'options': ['Surah Al-Baqarah', 'Surah Al-Imran', 'Surah An-Nisa', 'Surah At-Tawbah'],
          'answer': 'Surah Al-Baqarah',
        },
        {
          'question': 'Which Surah is known as "The Splitting"?',
          'options': ['Surah Al-Qamar', 'Surah Al-Fath', 'Surah Al-Ikhlas', 'Surah Al-Baqarah'],
          'answer': 'Surah Al-Qamar',
        },
        {
          'question': 'In which Surah is the verse "Wa lau annana" found?',
          'options': ['Surah Al-Araf', 'Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah At-Tawbah'],
          'answer': 'Surah Al-Araf',
        },
        {
          'question': 'Which Surah is the 108th Surah in the Quran?',
          'options': ['Surah Al-Kawthar', 'Surah Al-Baqarah', 'Surah Al-Fatiha', 'Surah Al-Ikhlas'],
          'answer': 'Surah Al-Kawthar',
        },
      ],
    };

    // Select the correct category's question pool
    questionPool = allQuestions[widget.category] ?? [];

    // Shuffle the questions to make each game unique
    questionPool.shuffle();
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _isAnswerCorrect = questionPool[_currentQuestionIndex]['answer'] == selectedAnswer;
    });

    if (_isAnswerCorrect) {
      setState(() {
        _score++;
      });
    }

    Future.delayed(const Duration(seconds: 1), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < questionPool.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswerCorrect = true;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('Your final score is: $_score/${questionPool.length}'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _currentQuestionIndex = 0;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        //backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${questionPool.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              questionPool[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Column(
              children: (questionPool[_currentQuestionIndex]['options'] as List<String>)
                  .map((option) => ElevatedButton(
                onPressed: () {
                  _checkAnswer(option);
                },
                //style: ElevatedButton.styleFrom(backgroundColor:  Colors.green),
                child: Text(option),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Current Score: $_score',
              style: const TextStyle(fontSize: 18),
            ),
            if (_selectedAnswer != null && !_isAnswerCorrect)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Correct Answer: ${questionPool[_currentQuestionIndex]['answer']}',
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

