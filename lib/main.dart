import 'package:flutter/material.dart';

//Group members: Mariam Omer, Jennifer Phan, Zoha Khundmiri
//In Class Assignment # 7
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: MainScreen(toggleTheme: () {
        setState(() {
          isDarkMode = !isDarkMode;
        });
      }),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const MainScreen({Key? key, required this.toggleTheme}) : super(key: key);
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Color selectedColor = Colors.black;

  void showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick a Text Color'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<Color>(
                    value: selectedColor,
                    items: [
                      Colors.black,
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                      Colors.orange,
                      Colors.purple,
                    ].map((color) {
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Text(
                          'Color',
                          style: TextStyle(color: color),
                        ),
                      );
                    }).toList(),
                    onChanged: (Color? newColor) {
                      if (newColor != null) {
                        setState(() {
                          selectedColor = newColor;
                        });
                        setDialogState(() {}); // Update dialog UI
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text('Select'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('In-Class Activity 7'),
          actions: [
            IconButton(
              icon: Icon(Icons.color_lens),
              onPressed: showColorPickerDialog,
            ),
            IconButton(
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: widget.toggleTheme,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.text_fields), text: "Fade Text"),
              Tab(icon: Icon(Icons.image), text: "Fade Image"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FadingTextScreen(selectedColor: selectedColor),
            FadingImageScreen(),
          ],
        ),
      ),
    );
  }
}

class FadingTextScreen extends StatefulWidget {
  final Color selectedColor;
  const FadingTextScreen({Key? key, required this.selectedColor})
      : super(key: key);

  @override
  _FadingTextScreenState createState() => _FadingTextScreenState();
}

class _FadingTextScreenState extends State<FadingTextScreen> {
  bool _isVisible = true;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: toggleVisibility,
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24, color: widget.selectedColor),
          ),
        ),
      ),
    );
  }
}

class FadingImageScreen extends StatefulWidget {
  @override
  _FadingImageScreenState createState() => _FadingImageScreenState();
}

class _FadingImageScreenState extends State<FadingImageScreen>
    with SingleTickerProviderStateMixin {
  bool _isImageVisible = true;
  bool _showFrame = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void toggleImageVisibility() {
    setState(() {
      _isImageVisible = !_isImageVisible;
    });
  }

  void toggleFrame() {
    setState(() {
      _showFrame = !_showFrame;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: toggleImageVisibility,
          child: AnimatedOpacity(
            opacity: _isImageVisible ? 1.0 : 0.0,
            duration: Duration(seconds: 2),
            child: RotationTransition(
              turns: _rotationController,
              child: Container(
                padding: EdgeInsets.all(_showFrame ? 8.0 : 0.0),
                decoration: BoxDecoration(
                  border: _showFrame
                      ? Border.all(color: Colors.blue, width: 4)
                      : null,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    'assets/martin.jpg',
                    width: 200,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        SwitchListTile(
          title: Text('Show Frame'),
          value: _showFrame,
          onChanged: (bool value) {
            toggleFrame();
          },
        ),
      ],
    );
  }
}
