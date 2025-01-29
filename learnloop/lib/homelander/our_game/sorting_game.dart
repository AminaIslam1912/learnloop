import 'package:flutter/material.dart';


class SortingGame extends StatefulWidget {
  const SortingGame({super.key});

  @override
  State<SortingGame> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<SortingGame> {
  List<List<int>> grid = [];
  int emptyRow = 3, emptyCol = 3;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid() {
    grid = List.generate(4, (row) => List.generate(4, (col) => row * 4 + col + 1));
    grid[3][3] = 0;
    _shuffleGrid();
  }

  void _shuffleGrid() {
    List<int> tiles = grid.expand((row) => row).toList();
    tiles.shuffle();

    while (!_isSolvable(tiles)) {
      tiles.shuffle();
    }

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

    for (int i = 0; i < tiles.length; i++) {
      for (int j = i + 1; j < tiles.length; j++) {
        if (tiles[i] > tiles[j] && tiles[i] != 0 && tiles[j] != 0) {
          inversions++;
        }
      }
    }

    int blankRowFromBottom = 3 - emptyRow;
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
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 6,
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
                      color: grid[row][col] == 0 ? Colors.grey : Colors.green,
                      child: Center(
                        child: Text(
                          grid[row][col] == 0 ? '' : grid[row][col].toString(),
                          style: const TextStyle(fontSize: 24, color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 1),
            OutlinedButton(
              onPressed: _shuffleGrid,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),

              child: const Text(
                'Shuffle',
                style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
