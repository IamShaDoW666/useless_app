import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final myController = TextEditingController();
  String text = '';
  String from = "English";
  String to = "Malayalam";
  List<String> languages = [
    "English",
    "Malayalam",
    "Spanish",
    "Hindi",
    "Portuguese",
    "Russian",
    "German",
    "French",
    "Italian",
    "Arabic",
    "Telugu",
    "Tamil",
    "Japanese",
  ];
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Pointless Translator",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text("From"),
                  DropdownButton<String>(
                    value: from,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        from = newValue!;
                      });
                    },
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text("To"),
                  DropdownButton<String>(
                    value: to,
                    icon: const Icon(Icons.arrow_drop_down  ),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        to = newValue!;
                      });
                    },
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ).paddingAll(12),
          TextField(
            style: const TextStyle(fontSize: 32),
            controller: myController,
            decoration: InputDecoration(
              hintText: "Enter Text",
              filled: true,
              fillColor: const Color.fromARGB(
                  231, 255, 241, 186), // background color of the TextField
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0), // rounded corners
                borderSide: BorderSide.none, // hides the default border line
              ),
            ),
          ),
          32.height,
          ElevatedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  Future.delayed(
                    const Duration(milliseconds: 1200),
                    () {
                      setState(() {
                        loading = false;
                      });
                    },
                  );
                  text = myController.text;
                });
              },
              child: const Text(
                "Translate",
                style: TextStyle(fontSize: 22),
              ).paddingAll(8)),
          32.height,
          Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: !loading
                  ? Text(
                      text,
                      style: const TextStyle(fontSize: 32),
                    )
                  : const CircularProgressIndicator(),
            ).paddingAll(16),
          )
        ],
      ).paddingAll(16),
    );
  }
}
