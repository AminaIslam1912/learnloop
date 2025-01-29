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

  final int gridSize = 3;
  late List<List<bool>> _lights;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _lights = List.generate(
      gridSize,
          (_) => List.generate(gridSize, (_) => false),
    );


    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (DateTime.now().millisecond % 2 == 0) {
          _toggleLights(i, j, false);
        }
      }
    }
  }

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


  void _toggle(int row, int col) {
    if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
      _lights[row][col] = !_lights[row][col];
    }
  }


  bool _checkWinCondition() {
    for (var row in _lights) {
      for (var light in row) {
        if (light) return false;
      }
    }
    return true;
  }

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
