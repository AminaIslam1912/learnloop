import 'package:flutter/material.dart';



class MazeGame extends StatelessWidget {
  const MazeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Maze Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MazeScreen(),
    );
  }
}

class MazeScreen extends StatefulWidget {
  const MazeScreen({super.key});

  @override
  State<MazeScreen> createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  // List of maze layouts (0 = path, 1 = wall, 2 = player start, 3 = goal)
  final List<List<List<int>>> levels = [
    // Level 1 - Easy
    [
      [2, 1, 0, 0, 0],
      [0, 1, 0, 1, 0],
      [0, 0, 0, 1, 0],
      [1, 1, 0, 0, 0],
      [0, 0, 0, 1, 3],
    ],
    // Level 2 - Medium
    [
      [2, 1, 0, 0, 0, 1, 0],
      [0, 1, 0, 1, 0, 0, 0],
      [0, 0, 0, 1, 1, 1, 0],
      [1, 1, 0, 0, 0, 1, 0],
      [0, 0, 0, 1, 0, 0, 0],
      [0, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 1, 3],
    ],
    // Level 3 - Hard
    [
      [2, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 0, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 1, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 0],
      [0, 0, 0, 0, 0, 0, 1, 0],
      [1, 1, 1, 1, 1, 0, 1, 0],
      [0, 0, 0, 0, 0, 0, 1, 0],
      [1, 1, 1, 1, 1, 0, 0, 3],
    ],
  ];

  int currentLevel = 0;
  int playerX = 0;
  int playerY = 0;
  bool hasWon = false;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    _findPlayerStart();
  }

  void _findPlayerStart() {
    final currentMaze = levels[currentLevel];
    for (int y = 0; y < currentMaze.length; y++) {
      for (int x = 0; x < currentMaze[y].length; x++) {
        if (currentMaze[y][x] == 2) {
          playerX = x;
          playerY = y;
          return;
        }
      }
    }
  }

  void movePlayer(DragUpdateDetails details) {
    if (hasWon) return;

    final dx = details.delta.dx;
    final dy = details.delta.dy;
    final currentMaze = levels[currentLevel];

    setState(() {
      if (dx.abs() > dy.abs()) {
        // Horizontal movement
        if (dx > 0 && playerX < currentMaze[0].length - 1 && currentMaze[playerY][playerX + 1] != 1) {
          playerX++;
          moves++;
        } else if (dx < 0 && playerX > 0 && currentMaze[playerY][playerX - 1] != 1) {
          playerX--;
          moves++;
        }
      } else {
        // Vertical movement
        if (dy > 0 && playerY < currentMaze.length - 1 && currentMaze[playerY + 1][playerX] != 1) {
          playerY++;
          moves++;
        } else if (dy < 0 && playerY > 0 && currentMaze[playerY - 1][playerX] != 1) {
          playerY--;
          moves++;
        }
      }

      // Check if player reached the goal
      if (currentMaze[playerY][playerX] == 3) {
        if (currentLevel < levels.length - 1) {
          // Next level
          currentLevel++;
          _findPlayerStart();
          moves = 0;
        } else {
          // Game completed
          hasWon = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentMaze = levels[currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level ${currentLevel + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Moves: $moves',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onPanUpdate: movePlayer,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: List.generate(
                    currentMaze.length,
                        (y) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        currentMaze[y].length,
                            (x) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getCellColor(x, y),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (hasWon)
              const Text(
                'Congratulations! You completed all levels!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _findPlayerStart();
                      moves = 0;
                    });
                  },
                  child: const Text('Reset Level'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentLevel = 0;
                      hasWon = false;
                      moves = 0;
                      _findPlayerStart();
                    });
                  },
                  child: const Text('Reset Game'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCellColor(int x, int y) {
    if (x == playerX && y == playerY) {
      return Colors.blue; // Player
    } else if (levels[currentLevel][y][x] == 1) {
      return Colors.black; // Wall
    } else if (levels[currentLevel][y][x] == 3) {
      return Colors.green; // Goal
    }
    return Colors.white; // Path
  }
}