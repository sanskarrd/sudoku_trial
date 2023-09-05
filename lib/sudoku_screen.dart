import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:math';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
enum Difficulty { Easy, Medium, Hard }
class SudokuScreen extends StatefulWidget {
   final Difficulty difficulty;
 SudokuScreen({required this.difficulty});
  @override
  _SudokuScreenState createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
    late Difficulty difficulty; // Add this declaration here
  

  String selectedNum = "1";
  int selectedCellIndex = -1;
  int selectedNumberIndex = -1;
  bool showSelectedNumberAnimation = false;
  Color prefilledNumberColor = Colors.black; // Color for pre-filled numbers
  Color enteredNumberColor = Colors.blue;
  List<List<int>> solvedSudoku = [];
  bool isEnteringNumber = false;
  List<List<int>> initialSudokuGrid = List.generate(9, (_) => List.generate(9, (_) => 0));

  List<Color> gridBackgroundColors = [
    Colors.redAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ];
  Color selectedGridColor = Colors.blueGrey; // Initialize with a default color

  void changeGridBackgroundColor(Color color) {
    setState(() {
      selectedGridColor = color;
    });
  }

  void clearSelections() {
  setState(() {
    selectedCellIndex = -1;
    selectedNumberIndex = -1;
    showSelectedNumberAnimation = false;

    // Reset the Sudoku grid to its initial state
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        sudokuGrid[i][j] = initialSudokuGrid[i][j];
      }
    }
  });
}
 
bool isSudokuValid() {
  // Check rows, columns, and 3x3 grids for duplicate numbers
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      int value = sudokuGrid[i][j];
      if (value != 0) {
        // Check row
        for (int k = 0; k < 9; k++) {
          if (k != j && sudokuGrid[i][k] == value) {
            return false;
          }
        }
        // Check column
        for (int k = 0; k < 9; k++) {
          if (k != i && sudokuGrid[k][j] == value) {
            return false;
          }
        }
        // Check 3x3 grid
        int startRow = (i ~/ 3) * 3;
        int startCol = (j ~/ 3) * 3;
        for (int row = startRow; row < startRow + 3; row++) {
          for (int col = startCol; col < startCol + 3; col++) {
            if ((row != i || col != j) && sudokuGrid[row][col] == value) {
              return false;
            }
          }
        }
      }
    }
  }
  return true;
}


  bool isPuzzleSolved() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (sudokuGrid[i][j] != solvedSudoku[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  List<List<int>> sudokuGrid =
      List.generate(9, (_) => List.generate(9, (_) => 0));
   SudokuGenerator generator = SudokuGenerator(emptySquares: 5);
  SudokuSolver solver = SudokuSolver();

 void generateSudoku() {
  int emptySquares = 0;
   switch (widget.difficulty) {
    case Difficulty.Easy:
      emptySquares = 5; // Adjust this value as needed for Easy level
      break;
    case Difficulty.Medium:
      emptySquares = 20; // Adjust this value as needed for Medium level
      break;
    case Difficulty.Hard:
      emptySquares = 30; // Adjust this value as needed for Hard level
      break;
    default:
      emptySquares = 5; // Default to Easy
      break;
  }
    generator = SudokuGenerator(emptySquares: emptySquares);

  List<List<int>> newSudoku = generator.newSudoku;
  List<List<int?>> unsolvedSudoku = [];
  for (int i = 0; i < 9; i++) {
    unsolvedSudoku.add(List.from(newSudoku[i]));
  }
  solvedSudoku = SudokuSolver.solve(unsolvedSudoku);
  setState(() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        sudokuGrid[i][j] = newSudoku[i][j];
      }
    }
  });
}

  void solveSudoku() {
    List<List<int?>> unsolvedSudoku = [];
    for (int i = 0; i < 9; i++) {
      unsolvedSudoku.add(List.from(sudokuGrid[i]));
    }
    List<List<int?>> solvedSudoku = SudokuSolver.solve(unsolvedSudoku);
    if (solvedSudoku.isNotEmpty) {
      setState(() {
        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            sudokuGrid[i][j] = solvedSudoku[i][j]!;
          }
        }
      });
    } else {
      // Handle the case where the puzzle cannot be solved.
    }
  }

  @override
  void initState() {
  super.initState();
    generateSudoku();
   initialSudokuGrid = List.generate(9, (i) => List.generate(9, (j) => sudokuGrid[i][j]));

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFD3D3D3),
        lightSource: LightSource.topLeft,
        depth: 1,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: NeumorphicAppBar(
            title: Text(
              'Sudoku',
              style: TextStyle(
                color: _textColor(context),
              ),
            ),
            actions: [
              NeumorphicButton(
                child: Icon(
                  Icons.refresh_outlined,
                  color: _iconColor(context),
                ),
                onPressed: clearSelections,
              ),
              NeumorphicButton(
                child: Icon(
                  Icons.palette,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select Theme Color'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: gridBackgroundColors.map((color) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color,
                                radius: 20,
                              ),
                              title: Text('Grid Color'),
                              onTap: () {
                                changeGridBackgroundColor(color);
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    int row = index ~/ 9;
                    int col = index % 9;
                    int value = sudokuGrid[row][col];

                    int gridIndex = (row ~/ 3) * 3 + (col ~/ 3);
                    Color gridColor;
                    if ([1, 3, 5, 7].contains(gridIndex)) {
                      // Check if the grid index should be colored
                      gridColor =
                          Colors.blueGrey; // Set the color for specific grids
                    } else {
                      gridColor = Colors
                          .transparent; // Set default color for other grids
                    }
                    bool isUserEntered =
                        value != 0 && sudokuGrid[row][col] == 0;

                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: NeumorphicButton(
                        onPressed: () {
                          setState(() {
                            selectedCellIndex = index;
                            isEnteringNumber = true;
                          });
                        },
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(2),
                          ),
                          color: selectedCellIndex == index
                              ? isEnteringNumber
                                  ? Colors.blue
                                  : Color.fromARGB(0, 69, 65, 65)
                              : gridColor,
                          depth: isEnteringNumber
                              ? 8
                              : 0, // Add elevation when entering a number
                          border: NeumorphicBorder(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            value == 0 ? "" : value.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: isUserEntered
                                  ? enteredNumberColor
                                  : (value == 0
                                      ? _textColor(context)
                                      : prefilledNumberColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 81,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(9, (index) {
                  String num = (index + 1).toString();
                  return GestureDetector(
                    onTap: () {
                      if (selectedCellIndex != -1) {
                        int row = selectedCellIndex ~/ 9;
                        int col = selectedCellIndex % 9;
                              int newValue = int.parse(num);
if (sudokuGrid[row][col] != newValue && !isSudokuValid()) {
        // Show an alert dialog for invalid input
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Input'),
              content: Text('The entered number violates Sudoku rules.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Exit early if the input is invalid
      }

                        setState(() {
                          selectedNum = num;
                          selectedNumberIndex = index;
                          sudokuGrid[row][col] = int.parse(num);
                          showSelectedNumberAnimation = true;
                          isEnteringNumber = false; // Reset isEnteringNumber

                          if (isPuzzleSolved()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Congratulations!'),
                                  content: Text(
                                      'You have successfully solved the Sudoku puzzle.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          Future.delayed(Duration(milliseconds: 300), () {
                            setState(() {
                              showSelectedNumberAnimation = false;
                            });
                          });
                        });
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedNumberIndex == index
                            ? Colors.grey
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            num,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (showSelectedNumberAnimation)
                            Positioned(
                              top: 30,
                              left: 0,
                              child: AnimatedOpacity(
                                opacity:
                                    showSelectedNumberAnimation ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 300),
                                child: Text(
                                  selectedNum,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _textColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

Color _iconColor(BuildContext context) {
  if (NeumorphicTheme.isUsingDark(context)) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
