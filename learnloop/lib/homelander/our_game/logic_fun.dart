import 'package:flutter/material.dart';



class LightsOutGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LightsOutScreen(),
    );
  }
}

class LightsOutScreen extends StatefulWidget {
  const LightsOutScreen({super.key});

  @override
  State<LightsOutScreen> createState() => _LightsOutScreenState();
}

class _LightsOutScreenState extends State<LightsOutScreen> {
  // Grid size (can be changed to 5 for a 5x5 grid)
  final int gridSize = 3;

  // The game board, initialized randomly
  late List<List<bool>> _lights;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  // Initializes the game board with random light states
  void _initializeBoard() {
    _lights = List.generate(
      gridSize,
          (_) => List.generate(gridSize, (_) => false),
    );

    // Randomly toggle some lights to create a starting configuration
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (DateTime.now().millisecond % 2 == 0) {
          _toggleLights(i, j, false);
        }
      }
    }
  }

  // Toggles the light at (row, col) and its adjacent lights
  void _toggleLights(int row, int col, [bool updateState = true]) {
    if (updateState) {
      setState(() {
        _toggle(row, col); // Toggle the selected cell
        _toggle(row - 1, col); // Toggle above
        _toggle(row + 1, col); // Toggle below
        _toggle(row, col - 1); // Toggle left
        _toggle(row, col + 1); // Toggle right
      });
    } else {
      _toggle(row, col); // Toggle the selected cell
      _toggle(row - 1, col); // Toggle above
      _toggle(row + 1, col); // Toggle below
      _toggle(row, col - 1); // Toggle left
      _toggle(row, col + 1); // Toggle right
    }
  }

  // Toggles a specific cell if it exists within bounds
  void _toggle(int row, int col) {
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      _lights[row][col] = !_lights[row][col];
    }
  }

  // Checks if all lights are turned off
  bool _checkWinCondition() {
    for (var row in _lights) {
      for (var light in row) {
        if (light) return false;
      }
    }
    return true;
  }

  // Resets the game board
  void _resetGame() {
    setState(() {
      _initializeBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lights Out Puzzle'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_checkWinCondition())
              Column(
                children: [
                  const Text(
                    'Congratulations! You solved the puzzle!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Play Again'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const Text(
                    'Tap the lights to turn them all off!\nPressing one light will toggle 4 adjacent lights',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  for (int row = 0; row < gridSize; row++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int col = 0; col < gridSize; col++)
                          GestureDetector(
                            onTap: () => _toggleLights(row, col),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              width: 80,
                              height: 80,
                              color: _lights[row][col] ? Colors.yellow : Colors.grey[800],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
