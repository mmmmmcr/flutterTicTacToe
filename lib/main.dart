import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<Color, int> colorMapping = <Color, int>{Colors.red: 0, Colors.green: 1};
  final List<Color> tileColors = List.filled(9, Colors.transparent);
  final List<Color> playerToColor = <Color>[Colors.red, Colors.green];
  int currentPlayer = 0;
  int coloredTiles = 0;
  bool isGameOver = false;
  final List<List<int>> combinations = <List<int>>[
    <int>[0, 1, 2],
    <int>[3, 4, 5],
    <int>[6, 7, 8],
    <int>[0, 3, 6],
    <int>[1, 4, 7],
    <int>[2, 5, 8],
    <int>[0, 4, 8],
    <int>[2, 4, 6]
  ];

  void tappedTile(int index) {
    if (tileColors[index] != Colors.transparent || isGameOver) {
      return;
    }

    setState(() {
      tileColors[index] = playerToColor[currentPlayer];
      ++coloredTiles;

      int winner = -1;

      final Pair<int, List<int>> result = checkResult();
      winner = result.first;
      final List<int> combination = result.second;
      if (winner == -1) {
        setState(() {
          if (coloredTiles == 9) {
            return;
          }
          tileColors[index] = playerToColor[currentPlayer];

          if (currentPlayer == 0) {
            currentPlayer = 1;
          } else {
            currentPlayer = 0;
          }
        });
      } else {
        {
          for (int i = 0; i < 9; ++i) {
            if (tileColors[i] == Colors.transparent) {
              continue;
            }
            if (combination.contains(i) == false) {
              tileColors[i] = Colors.transparent;
            }
          }
          isGameOver = true;
        }
      }
    });
  }

  Pair<int, List<int>> checkResult() {
    for (final List<int> combination in combinations) {
      if (tileColors[combination[0]] == Colors.transparent ||
          tileColors[combination[1]] == Colors.transparent ||
          tileColors[combination[2]] == Colors.transparent) {
        continue;
      }

      final Color color = tileColors[combination[0]];
      final int player = colorMapping[color] ?? 0;

      if (color == tileColors[combination[1]] && color == tileColors[combination[2]]) {
        return Pair<int, List<int>>(player, combination);
      }
    }
    return Pair<int, List<int>>(-1, List.empty());
  }

  void resetGame() {
    coloredTiles = 0;
    setState(() {
      for (int i = 0; i < 9; ++i) {
        tileColors[i] = Colors.transparent;
      }
      isGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.yellow,
            centerTitle: true,
            title: const Text(
              'tic-tac-toe',
              style: TextStyle(color: Colors.black),
            )),
        body: Column(
          children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 0),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      tappedTile(index);
                    },
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        color: tileColors[index],
                      ),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                }),
            const SizedBox(height: 16),
            Visibility(
              visible: isGameOver,
              child: ElevatedButton(
                onPressed: () {
                  resetGame();
                },
                child: const Text('Play again!'),
              ),
            )
          ],
        ));
  }
}