import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sudoku_trial/sudoku_screen.dart';
const Difficulty easy = Difficulty.Easy;
// const Difficulty medium = Difficulty.Medium;
// const Difficulty hard = Difficulty.Hard;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku App',
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFE0E0E0), // Light grayish background
        lightSource: LightSource.topLeft,
        depth: 6, // Slightly reduced depth
        appBarTheme: NeumorphicAppBarThemeData(
          buttonStyle: NeumorphicStyle(
            color: Color(0xFFD1D1D1), // Light gray for app bar buttons
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(12),
            ),
          ),
          textStyle: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF222222),
        lightSource: LightSource.topLeft,
        depth: 4,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) => HomePage(),
        '/mainScreen': (context) => SudokuScreen(difficulty: easy,),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final player = AudioPlayer();
  Difficulty selectedDifficulty = Difficulty.Easy; // Define the difficulty variable

  void _showInstructionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InstructionDialog();
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingDialog();
      },
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Info',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue, // Change title text color
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              'Sanskar\'s Sudoku App\n\n'
              'This Sudoku app is developed by Sanskar. '
              'Enjoy playing Sudoku and have fun!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Change content text color
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red, // Change button text color
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Add rounded corners
          ),
          backgroundColor: Colors.white, // Change background color
          elevation: 4.0, // Add a slight shadow
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
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
                    Icons.info_outline,
                    color: _iconColor(context),
                  ),
                  onPressed: _showInfoDialog),
              NeumorphicButton(
                child: Icon(
                  Icons.sunny,
                  color: _iconColor(context),
                ),
                onPressed: () {
                  NeumorphicTheme.of(context)?.themeMode =
                      NeumorphicTheme.isUsingDark(context)
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.asset(
                  'assets/Green Sudoku App Icon.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 100),
              NeumorphicButton(
                style: NeumorphicStyle(
                  color: Colors.white60,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(32)),
                ),
                onPressed: () async {
                  await player.play(AssetSource('click-21156.mp3'));
            Navigator.pushNamed(context, '/mainScreen', arguments: selectedDifficulty);
                },
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: Center(
                    child: Text(
                      'Play',
                      style: TextStyle(
                        color: _textColor(context),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              NeumorphicButton(
                style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(32)),
                ),
                onPressed: _showSettingsDialog,
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: _textColor(context),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              NeumorphicButton(
                style: NeumorphicStyle(
                  color: Colors.white60,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(32)),
                ),
                onPressed: _showInstructionsDialog,
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: Center(
                    child: Text(
                      'Instructions',
                      style: TextStyle(
                        color: _textColor(context),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to your main screen after the splash
      Navigator.pushReplacementNamed(context, '/');
    });
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.asset(
                'assets/logo.jpeg',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 40),
            Text(
              'SUDOKU',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            // Add your splash screen UI elements here
            CircularProgressIndicator(), // Example: Progress indicator
            SizedBox(height: 20),
            Text("Welcome..."), // Example: Loading text
          ],
        ),
      ),
    );
  }
}

class InstructionDialog extends StatefulWidget {
  @override
  _InstructionDialogState createState() => _InstructionDialogState();
}

class _InstructionDialogState extends State<InstructionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sudoku Instructions'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Welcome to Sudoku! Here are some instructions to get started:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
                '1. Fill each row, column, and 3x3 grid with numbers from 1 to 9.'),
            SizedBox(height: 10),
            Text(
                '2. Each number can appear only once in each row, column, and grid.'),
            SizedBox(height: 10),
            Text(
                '3. Some numbers are already provided as clues to help you get started.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  Difficulty selectedDifficulty = Difficulty.Easy; // Default difficulty

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Select Level',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        selectionColor: Colors.redAccent,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Easy',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedDifficulty = Difficulty.Easy;
                });
              },
              leading: Radio(
                value: Difficulty.Easy,
                groupValue: selectedDifficulty,
                onChanged: (Difficulty? value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Medium',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedDifficulty = Difficulty.Medium;
                });
              },
              leading: Radio(
                value: Difficulty.Medium,
                groupValue: selectedDifficulty,
                onChanged: (Difficulty? value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Hard',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedDifficulty = Difficulty.Hard;
                });
              },
              leading: Radio(
                value: Difficulty.Hard,
                groupValue: selectedDifficulty,
                onChanged: (Difficulty? value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDifficulty); // Close the dialog with selected difficulty
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}