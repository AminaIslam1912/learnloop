import 'package:flutter/material.dart';




class DsaQuiz extends StatelessWidget {
  final List<String> categories = [
    'Arrays', 'Linked Lists', 'Stacks', 'Queues', 'Trees', 'Graphs'
  ];

  final List<List<Map<String, dynamic>>> questions = [
    // Arrays
    [
      {'question': 'What is the time complexity of accessing an element in an array?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'What is the space complexity of an array?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'What is the time complexity of searching an element in an unsorted array?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'What is the time complexity of inserting an element at the end of an array?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'How is memory allocated in arrays?', 'options': ['Contiguous block of memory', 'Non-contiguous block of memory', 'Dynamic allocation', 'None of the above'], 'correctAnswer': 'Contiguous block of memory'},
      {'question': 'Which of the following is a characteristic of an array?', 'options': ['Dynamic size', 'Fixed size', 'Unordered elements', 'None of the above'], 'correctAnswer': 'Fixed size'},
      {'question': 'In an array, what does index 0 represent?', 'options': ['First element', 'Last element', 'Middle element', 'None of the above'], 'correctAnswer': 'First element'},
      {'question': 'What is the time complexity of deleting an element from an unsorted array?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'What type of array supports dynamic resizing?', 'options': ['Static Array', 'Dynamic Array', 'Linked List', 'None of the above'], 'correctAnswer': 'Dynamic Array'},
      {'question': 'Which operation on an array has the best time complexity?', 'options': ['Insert at beginning', 'Insert at end', 'Search', 'Delete'], 'correctAnswer': 'Insert at end'}
    ],
    // Linked Lists
    [
      {'question': 'What is the time complexity of inserting at the head of a singly linked list?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'What is the space complexity of a singly linked list?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'Which of the following is true for linked lists?', 'options': ['Fixed size', 'Dynamic size', 'Random access', 'None of the above'], 'correctAnswer': 'Dynamic size'},
      {'question': 'What is the time complexity of searching for an element in a singly linked list?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'Which operation is most efficient for a linked list?', 'options': ['Search', 'Insert at head', 'Insert at tail', 'Delete'], 'correctAnswer': 'Insert at head'},
      {'question': 'Which pointer is used to traverse a singly linked list?', 'options': ['Head', 'Tail', 'Both Head and Tail', 'None of the above'], 'correctAnswer': 'Head'},
      {'question': 'What is the time complexity of deleting the last node in a singly linked list?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'What type of linked list has pointers for both next and previous nodes?', 'options': ['Singly linked list', 'Doubly linked list', 'Circular linked list', 'None of the above'], 'correctAnswer': 'Doubly linked list'},
      {'question': 'In a circular linked list, which node points to the first node?', 'options': ['Last node', 'First node', 'Middle node', 'Head node'], 'correctAnswer': 'Last node'},
      {'question': 'What is the time complexity of inserting an element at the tail of a doubly linked list?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'}
    ],
    // Stacks
    [
      {'question': 'What is the time complexity of pushing an element onto a stack?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'What type of data structure is a stack?', 'options': ['LIFO', 'FIFO', 'Random access', 'None of the above'], 'correctAnswer': 'LIFO'},
      {'question': 'What is the time complexity of popping an element from a stack?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'In a stack, what does the "peek" operation do?', 'options': ['Removes the top element', 'Returns the top element', 'Adds an element to the top', 'None of the above'], 'correctAnswer': 'Returns the top element'},
      {'question': 'Which of the following is true for a stack?', 'options': ['It follows the FIFO principle', 'It follows the LIFO principle', 'It allows random access', 'None of the above'], 'correctAnswer': 'It follows the LIFO principle'},
      {'question': 'What is the space complexity of a stack?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'Which of the following is an application of stacks?', 'options': ['Undo functionality in text editors', 'Memory management', 'Browser history', 'All of the above'], 'correctAnswer': 'All of the above'},
      {'question': 'What happens when a stack is full?', 'options': ['It overflows', 'It gets emptied', 'It grows dynamically', 'None of the above'], 'correctAnswer': 'It overflows'},
      {'question': 'What type of operation does a stack use to add an element?', 'options': ['Push', 'Pop', 'Peek', 'None of the above'], 'correctAnswer': 'Push'},
      {'question': 'What is the time complexity of checking if a stack is empty?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'}
    ],
    // Queues
    [
      {'question': 'What is the time complexity of enqueueing an element in a queue?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'What is the time complexity of dequeueing an element from a queue?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'Which type of queue allows enqueue and dequeue from both ends?', 'options': ['Circular Queue', 'Priority Queue', 'Deque', 'None of the above'], 'correctAnswer': 'Deque'},
      {'question': 'What is the time complexity of checking if a queue is empty?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(1)'},
      {'question': 'Which data structure follows the FIFO principle?', 'options': ['Stack', 'Queue', 'Array', 'Linked List'], 'correctAnswer': 'Queue'},
      {'question': 'What is the space complexity of a queue?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'What is the function of the front pointer in a queue?', 'options': ['Points to the last element', 'Points to the first element', 'Points to the middle element', 'None of the above'], 'correctAnswer': 'Points to the first element'},
      {'question': 'Which of the following is an application of queues?', 'options': ['Print job scheduling', 'Undo functionality', 'Memory management', 'None of the above'], 'correctAnswer': 'Print job scheduling'},
      {'question': 'Which type of queue has fixed size and wraps around?', 'options': ['Circular Queue', 'Priority Queue', 'Deque', 'None of the above'], 'correctAnswer': 'Circular Queue'},
      {'question': 'In a priority queue, how is the highest priority element handled?', 'options': ['It is removed first', 'It is added last', 'It is handled randomly', 'None of the above'], 'correctAnswer': 'It is removed first'}
    ],
    // Trees
    [
      {'question': 'What is the time complexity of searching for an element in a binary search tree (BST)?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(log n)'},
      {'question': 'What is the space complexity of a binary tree?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(n)'},
      {'question': 'In a binary tree, what is the maximum number of nodes at level n?', 'options': ['2^n', '2^n-1', 'n^2', 'None of the above'], 'correctAnswer': '2^n'},
      {'question': 'What is the time complexity of inserting an element in a binary search tree (BST)?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(log n)'},
      {'question': 'In a full binary tree, how many leaves does it have?', 'options': ['n', 'n/2', 'n+1', '2n'], 'correctAnswer': 'n/2'},
      {'question': 'Which traversal technique is used to visit all nodes in a binary tree?', 'options': ['Preorder', 'Inorder', 'Postorder', 'All of the above'], 'correctAnswer': 'All of the above'},
      {'question': 'What is the time complexity of deleting an element from a binary search tree?', 'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'correctAnswer': 'O(log n)'},
      {'question': 'Which traversal technique gives the nodes of a binary tree in non-decreasing order?', 'options': ['Preorder', 'Inorder', 'Postorder', 'None of the above'], 'correctAnswer': 'Inorder'},
      {'question': 'What is a binary search tree (BST)?', 'options': ['A tree where each node has at most two children', 'A tree with nodes in random order', 'A tree with nodes in increasing order', 'None of the above'], 'correctAnswer': 'A tree where each node has at most two children'},
      {'question': 'Which type of tree allows efficient searching and sorting?', 'options': ['Binary tree', 'Binary search tree', 'Heap', 'None of the above'], 'correctAnswer': 'Binary search tree'}
    ],
    // Graphs
    [
      {'question': 'What is the time complexity of searching for an element in an undirected graph using BFS?', 'options': ['O(1)', 'O(n)', 'O(E)', 'O(V+E)'], 'correctAnswer': 'O(V+E)'},
      {'question': 'What is the space complexity of storing an undirected graph using an adjacency matrix?', 'options': ['O(1)', 'O(n)', 'O(n^2)', 'O(n+e)'], 'correctAnswer': 'O(n^2)'},
      {'question': 'In a graph, what is the maximum number of edges in a complete graph with n nodes?', 'options': ['n', 'n^2', 'n(n-1)/2', '2n'], 'correctAnswer': 'n(n-1)/2'},
      {'question': 'What is the time complexity of adding an edge in an undirected graph using an adjacency list?', 'options': ['O(1)', 'O(n)', 'O(E)', 'O(V+E)'], 'correctAnswer': 'O(1)'},
      {'question': 'What is the time complexity of BFS in an undirected graph with n nodes and m edges?', 'options': ['O(1)', 'O(n)', 'O(m)', 'O(n+m)'], 'correctAnswer': 'O(n+m)'},
      {'question': 'Which traversal technique is used to visit all nodes in a graph?', 'options': ['BFS', 'DFS', 'Both BFS and DFS', 'None of the above'], 'correctAnswer': 'Both BFS and DFS'},
      {'question': 'What is the time complexity of deleting an edge in an undirected graph using an adjacency list?', 'options': ['O(1)', 'O(n)', 'O(E)', 'O(V+E)'], 'correctAnswer': 'O(n)'},
      {'question': 'Which traversal technique gives the nodes of a graph in a topologically sorted order?', 'options': ['BFS', 'DFS', 'Topological Sort', 'None of the above'], 'correctAnswer': 'Topological Sort'},
      {'question': 'Which type of graph is directed and has no cycles?', 'options': ['Undirected graph', 'Directed acyclic graph (DAG)', 'Complete graph', 'None of the above'], 'correctAnswer': 'Directed acyclic graph (DAG)'},
      {'question': 'What is the time complexity of checking if a graph is connected?', 'options': ['O(1)', 'O(n)', 'O(V+E)', 'O(n^2)'], 'correctAnswer': 'O(V+E)'}
    ]


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSA Quiz')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizCategoryPage(
                    category: categories[index],
                    questions: questions[index],
                  ),
                ),
              );
            },
            child: Card(
              color: Colors.green,
              elevation: 5,
              child: Center(
                child: Text(
                  categories[index],
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizCategoryPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> questions;

  QuizCategoryPage({required this.category, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Quiz')),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return QuizQuestionCard(
            question: questions[index]['question'],
            options: questions[index]['options'],
            correctAnswer: questions[index]['correctAnswer'],

          );
        },
      ),
    );
  }
}

class QuizQuestionCard extends StatefulWidget {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestionCard({required this.question, required this.options, required this.correctAnswer});

  @override
  _QuizQuestionCardState createState() => _QuizQuestionCardState();
}

class _QuizQuestionCardState extends State<QuizQuestionCard> {
  String _selectedAnswer = '';
  String _feedback = '';

  void _checkAnswer() {
    setState(() {
      if (_selectedAnswer == widget.correctAnswer) {
        _feedback = 'Correct!';
      } else {
        _feedback = 'Incorrect! Correct answer: ${widget.correctAnswer}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Column(
              children: widget.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswer = value!;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Check Answer'),
            ),
            SizedBox(height: 8),
            Text(_feedback, style: TextStyle(fontSize: 14, color: _feedback.startsWith('Correct') ? Colors.green : Colors.red)),
          ],
        ),
      ),
    );
  }
}
