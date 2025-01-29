
import 'dart:math';
import 'package:flutter/material.dart';



class QuranQuiz extends StatelessWidget {
  final List<String> categories = [
    'General Quran Quiz',
    'Prophet Stories Quiz',
    'Surahs and Verses Quiz',
  ];

  QuranQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Quiz Game'),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.only(top: 16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // 2 cards per row
          crossAxisSpacing: 10,  // Spacing between columns
          mainAxisSpacing: 10,  // Spacing between rows
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.green,
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: InkWell(
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    categories[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}




class QuranQuizScreen extends StatefulWidget {
  final String category;

  const QuranQuizScreen({super.key, required this.category});

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
        title: Text(
          widget.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questionPool.length,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 8,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedAnswer != null)
                    Icon(
                      _isAnswerCorrect ? Icons.check_circle : Icons.error,
                      color: _isAnswerCorrect ? Colors.green : Colors.green,
                      size: 30,
                    ),
                ],
              ),

              // Question Header
              Text(
                'Question ${_currentQuestionIndex + 1}/${questionPool.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 10),

              // Question Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),

                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questionPool[_currentQuestionIndex]['question'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      //color: Colors.green,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options with Equal Button Size
              Expanded(
                child: ListView.builder(
                  itemCount: questionPool[_currentQuestionIndex]['options'].length,
                  itemBuilder: (context, index) {
                    String option = questionPool[_currentQuestionIndex]['options'][index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: double.infinity,
                      height: 60, // Set a fixed height for all buttons
                      child: ElevatedButton(
                        onPressed: () {
                          _checkAnswer(option);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(fontSize: 16,color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Current Score
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Score: $_score',
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     if (_selectedAnswer != null)
              //       Icon(
              //         _isAnswerCorrect ? Icons.check_circle : Icons.error,
              //         color: _isAnswerCorrect ? Colors.green : Colors.green,
              //         size: 30,
              //       ),
              //   ],
              // ),

              // Feedback Section
              if (_selectedAnswer != null && !_isAnswerCorrect)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Correct Answer: ${questionPool[_currentQuestionIndex]['answer']}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}

