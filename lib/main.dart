import 'package:flutter/material.dart';
import 'package:useless_app/screens/color_detector.dart';
import 'package:useless_app/screens/timer_screen.dart';
import 'package:useless_app/screens/translator_screen.dart';
import 'package:nb_utils/nb_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pointless Play',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(246, 190, 65, 1)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Pointless Play'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, String> nameMappings = {0: "Detector", 1: "Translator", 2: "Timer"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Number of columns
              crossAxisSpacing: 10.0, // Horizontal space between items
              mainAxisSpacing: 10.0, // Vertical space between items
              childAspectRatio: 3, // Aspect ratio of the containers
            ),
            itemCount: 3, // Total number of items
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      const ColorDetector().launch(context);
                      break;
                    case 1:
                      const TranslatorScreen().launch(context);
                      break;
                    case 2:
                      const TimerScreen().launch(context);
                      break;
                    default:
                      break;
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        nameMappings[index]!,
                        style: const TextStyle(fontSize: 22),
                      ),
                    )),
              );
            },
          ),
        ));
  }
}
