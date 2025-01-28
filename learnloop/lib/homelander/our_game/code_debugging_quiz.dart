import 'package:flutter/material.dart';



class CodeDebuggingQuiz extends StatelessWidget {
  final List<String> categories = ['C', 'C++', 'Python', 'Java'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugging Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a category:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two categories per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 2.0, // Adjust the aspect ratio for card size
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.green,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizScreen(category: categories[index]),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          categories[index],
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class QuizScreen extends StatefulWidget {
  final String category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Map<String, List<Map<String, dynamic>>> questionBank = {
    'C': [
      // Easy
      {
        'question': 'What is the correct syntax to print "Hello, World" in C?',
        'options': [
          'print("Hello, World");',
          'printf("Hello, World");',
          'cout << "Hello, World";',
          'System.out.println("Hello, World");',
        ],
        'answer': 'printf("Hello, World");',
        'explanation': 'The correct syntax for printing in C is using the `printf` function.',
      },
      {
        'question': 'Which header file is required to use the `printf` function in C?',
        'options': ['<math.h>', '<stdio.h>', '<stdlib.h>', '<string.h>'],
        'answer': '<stdio.h>',
        'explanation': 'The `printf` function is defined in the `<stdio.h>` header file.',
      },
      {
        'question': 'What is the output of this code?\n\n```c\nint main() {\n    int x = 5;\n    printf("%d", x * 2);\n    return 0;\n}\n```',
        'options': ['5', '10', 'Compilation error', 'Undefined'],
        'answer': '10',
        'explanation': 'The value of `x * 2` is 10, so the output is 10.',
      },
      // Medium
      {
        'question': 'What is the result of the following code?\n\n```c\nint main() {\n    int x = 5 / 2;\n    printf("%d", x);\n    return 0;\n}\n```',
        'options': ['2', '2.5', '5', 'Compilation error'],
        'answer': '2',
        'explanation': 'In C, integer division truncates the decimal part, so 5 / 2 equals 2.',
      },
      {
        'question': 'What is wrong with this code?\n\n```c\n#include <stdio.h>\nint main() {\n    char str[5] = "Hello";\n    printf("%s", str);\n    return 0;\n}\n```',
        'options': [
          'No error',
          'String overflow',
          'Improper format specifier',
          'Undefined behavior',
        ],
        'answer': 'String overflow',
        'explanation': 'The size of the array is 5, but "Hello" requires 6 characters (including the null terminator).',
      },
      // Hard
      {
        'question': 'What does the following code do?\n\n```c\nint main() {\n    int x = 0;\n    if (x = 5) {\n        printf("True");\n    } else {\n        printf("False");\n    }\n    return 0;\n}\n```',
        'options': ['True', 'False', 'Compilation error', 'Undefined'],
        'answer': 'True',
        'explanation': 'The condition `x = 5` assigns 5 to `x` and evaluates to true, so "True" is printed.',
      },
      {
        'question': 'What is the output of this code?\n\n```c\n#include <stdio.h>\nint main() {\n    int x = 3;\n    printf("%d", x << 1);\n    return 0;\n}\n```',
        'options': ['3', '6', '9', 'Compilation error'],
        'answer': '6',
        'explanation': 'The left shift operator (`<<`) shifts the bits of `x` by 1 position, effectively multiplying by 2.',
      },
    ],
    'C++': [
      // Easy
      {
        'question': 'What is the correct way to print "Hello, World" in C++?',
        'options': [
          'print("Hello, World");',
          'cout << "Hello, World";',
          'printf("Hello, World");',
          'System.out.println("Hello, World");',
        ],
        'answer': 'cout << "Hello, World";',
        'explanation': 'In C++, the `cout` object is used for output and requires the `<<` operator.',
      },
      {
        'question': 'Which header file is required to use `cout` in C++?',
        'options': ['<iostream>', '<stdio.h>', '<stdlib.h>', '<string.h>'],
        'answer': '<iostream>',
        'explanation': 'To use `cout` in C++, you need to include the `<iostream>` header file.',
      },
      {
        'question': 'What is the output of the following code?\n\n```cpp\n#include <iostream>\nint main() {\n    int x = 5;\n    std::cout << x * 2;\n    return 0;\n}\n```',
        'options': ['5', '10', 'Compilation error', 'Undefined'],
        'answer': '10',
        'explanation': 'The value of `x * 2` is 10, so the output is 10.',
      },
      // Medium
      {
        'question': 'What is wrong with the following code?\n\n```cpp\n#include <iostream>\nint main() {\n    int arr[3] = {1, 2, 3};\n    std::cout << arr[4];\n    return 0;\n}\n```',
        'options': [
          'No error',
          'Out of bounds access',
          'Segmentation fault',
          'Compilation error',
        ],
        'answer': 'Out of bounds access',
        'explanation': 'Accessing `arr[4]` is out of bounds as the array only has 3 elements.',
      },
      // Hard
      {
        'question': 'What is the output of the following code?\n\n```cpp\n#include <iostream>\nint main() {\n    int x = 2;\n    std::cout << x << std::endl;\n    std::cout << x * 2 << std::endl;\n    return 0;\n}\n```',
        'options': ['2\n4', '2\n6', '4\n6', 'Undefined'],
        'answer': '2\n4',
        'explanation': 'The first output is `x` which is 2, and the second output is `x * 2` which is 4.',
      },
    ],
    'Python': [
      // Easy
      {
        'question': 'What is the correct way to print "Hello, World" in Python?',
        'options': [
          'print("Hello, World")',
          'echo "Hello, World"',
          'printf("Hello, World")',
          'System.out.println("Hello, World")',
        ],
        'answer': 'print("Hello, World")',
        'explanation': 'In Python, the `print()` function is used to display output.',
      },
      {
        'question': 'Which of the following is used to define a function in Python?',
        'options': ['def', 'function', 'func', 'defun'],
        'answer': 'def',
        'explanation': 'In Python, the `def` keyword is used to define a function.',
      },
      {
        'question': 'What is the output of the following code?\n\n```python\nx = 5\nprint(x * 2)\n```',
        'options': ['5', '10', '2', 'Error'],
        'answer': '10',
        'explanation': 'The value of `x * 2` is 10, so the output is 10.',
      },
      // Medium
      {
        'question': 'What does the following Python code do?\n\n```python\nx = 5\nx += 2\nprint(x)\n```',
        'options': ['5', '7', '2', '8'],
        'answer': '7',
        'explanation': 'The `+=` operator adds 2 to `x`, so the output is 7.',
      },
      {
        'question': 'What is wrong with the following code?\n\n```python\nx = 5\nif x = 6:\n    print("Equal")\n```',
        'options': ['No error', 'Syntax error', 'Indentation error', 'Runtime error'],
        'answer': 'Syntax error',
        'explanation': 'The `=` operator is used for assignment, not comparison. It should be `==` for comparison.',
      },
    ],
    'Java': [
      // Easy
      {
        'question': 'What is the correct way to print "Hello, World" in Java?',
        'options': [
          'print("Hello, World");',
          'System.out.print("Hello, World");',
          'System.out.println("Hello, World");',
          'printf("Hello, World");',
        ],
        'answer': 'System.out.println("Hello, World");',
        'explanation': 'In Java, the `System.out.println()` method is used to print output with a newline.',
      },
      {
        'question': 'Which method is used to define the entry point of a Java program?',
        'options': ['main()', 'start()', 'run()', 'init()'],
        'answer': 'main()',
        'explanation': 'In Java, the entry point of a program is the `main()` method.',
      },
      {
        'question': 'What is the output of the following code?\n\n```java\npublic class Main {\n    public static void main(String[] args) {\n        int x = 10;\n        System.out.println(x / 2);\n    }\n}```',
        'options': ['5', '10', '2', 'Compilation error'],
        'answer': '5',
        'explanation': 'The value of `x / 2` is 5, so the output is 5.',
      },
      // Medium
      {
        'question': 'What is the result of the following code?\n\n```java\npublic class Main {\n    public static void main(String[] args) {\n        int x = 7 / 2;\n        System.out.println(x);\n    }\n}```',
        'options': ['3', '3.5', '4', '7'],
        'answer': '3',
        'explanation': 'In Java, integer division truncates the decimal part, so 7 / 2 equals 3.',
      },
      {
        'question': 'What is wrong with the following Java code?\n\n```java\npublic class Main {\n    public static void main(String[] args) {\n        String s = "Hello";\n        s[0] = "J";\n        System.out.println(s);\n    }\n}```',
        'options': [
          'No error',
          'String cannot be modified',
          'Index out of bounds error',
          'Compilation error',
        ],
        'answer': 'String cannot be modified',
        'explanation': 'Strings in Java are immutable, so you cannot modify individual characters of a string.',
      },
    ],
  };



  int currentQuestionIndex = 0;
  int score = 0;

  void checkAnswer(String selectedOption) {
    final questionData = questionBank[widget.category]![currentQuestionIndex];
    final isCorrect = selectedOption == questionData['answer'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? 'Correct!' : 'Wrong!'),
        content: Text(
          isCorrect
              ? 'Good job! 🎉'
              : 'Correct Answer: ${questionData['answer']}\n\nExplanation: ${questionData['explanation']}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (isCorrect) score++;
                if (currentQuestionIndex < questionBank[widget.category]!.length - 1) {
                  currentQuestionIndex++;
                } else {
                  _showCompletionDialog();
                }
              });
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Completed'),
        content: Text('Your score: $score/${questionBank[widget.category]!.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Go back to the previous page (category selection)
            },
            child: Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionData = questionBank[widget.category]![currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.category} Quiz',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Q${currentQuestionIndex + 1}: ${questionData['question']}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Options as Buttons
              Expanded(
                child: ListView.builder(
                  itemCount: questionData['options'].length,
                  itemBuilder: (context, index) {
                    final option = questionData['options'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(option),
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16.0),


            ],
          ),
        ),
      ),
    );
  }



}
