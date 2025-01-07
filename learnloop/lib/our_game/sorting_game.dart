import 'package:flutter/material.dart';



class GridPuzzleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzleScreen(),
    );
  }
}

class PuzzleScreen extends StatefulWidget {
  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  List<List<int>> grid = [];
  int emptyRow = 3, emptyCol = 3;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    // Initialize grid with sequential numbers and an empty cell
    grid = List.generate(4, (row) => List.generate(4, (col) => row * 4 + col + 1));
    grid[3][3] = 0; // Empty cell
    _shuffleGrid();
  }

  void _shuffleGrid() {
    // Flatten the grid into a single list for easier shuffling
    List<int> tiles = grid.expand((row) => row).toList();

    // Use Fisher-Yates shuffle algorithm to randomize tiles
    tiles.shuffle();

    // Ensure the puzzle is solvable (check inversion count)
    while (!_isSolvable(tiles)) {
      tiles.shuffle();
    }

    // Rebuild the grid with the shuffled tiles
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        grid[i][j] = tiles[i * 4 + j];
        if (grid[i][j] == 0) {
          emptyRow = i;
          emptyCol = j;
        }
      }
    }

    setState(() {});
  }

  bool _isSolvable(List<int> tiles) {
    int inversions = 0;

    // Count inversions (pairs of tiles where a larger number precedes a smaller one)
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[i] > tiles[j] && tiles[i] != 0 && tiles[j] != 0) {
          inversions++;
        }
      }
    }

    // For a 4x4 grid:
    // - If the blank is on an even row counting from the bottom, inversions must be odd.
    // - If the blank is on an odd row counting from the bottom, inversions must be even.
    int blankRowFromBottom = 3 - emptyRow; // Adjust for 0-indexed rows
    if (blankRowFromBottom % 2 == 0) {
      return inversions % 2 != 0;
    } else {
      return inversions % 2 == 0;
    }
  }

  void _moveTile(int row, int col) {
    if ((row == emptyRow && (col - emptyCol).abs() == 1) ||
        (col == emptyCol && (row - emptyRow).abs() == 1)) {
      setState(() {
        grid[emptyRow][emptyCol] = grid[row][col];
        grid[row][col] = 0;
        emptyRow = row;
        emptyCol = col;
      });
    }

    if (_isSolved()) {
      _showVictoryDialog();
    }
  }

  bool _isSolved() {
    int count = 1;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j] != (count % 16)) {
          return false;
        }
        count++;
      }
    }
    return true;
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Congratulations!"),
        content: const Text("You solved the puzzle!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeGrid();
            },
            child: const Text("Play Again"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid Puzzle"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                int row = index ~/ 4;
                int col = index % 4;
                return GestureDetector(
                  onTap: () => _moveTile(row, col),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    color: grid[row][col] == 0 ? Colors.grey : Colors.blue,
                    child: Center(
                      child: Text(
                        grid[row][col] == 0 ? '' : grid[row][col].toString(),
                        style: const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _shuffleGrid,
            child: const Text("Shuffle"),
          ),
        ],
      ),
    );
  }
}
