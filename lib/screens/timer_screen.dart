import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  late Duration _elapsedTime;
  late String _elapsedTimeString;
  late Timer _timer;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _elapsedTime = Duration.zero;
    _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _elapsedTime =
              _stopwatch.elapsed + Duration(seconds: random.nextInt(59));
          print(_elapsedTime.toString());
          _elapsedTimeString = _formatElapsedTime(_elapsedTime);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatElapsedTime(Duration duration) {
    int milliseconds = duration.inMilliseconds;
    int seconds = (milliseconds / 1000).floor();
    int minutes = (seconds / 60).floor();
    int hours = (minutes / 60).floor();

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    } else {
      _stopwatch.stop();
    }
    setState(() {}); // Update UI to reflect start/stop state
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime = Duration.zero;
      _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Pointless Timer",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              _elapsedTimeString,
              style: const TextStyle(fontSize: 64),
            ),
          ),
          32.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _startStopwatch();
                    });
                  },
                  icon: Icon(
                    !_stopwatch.isRunning ? Icons.play_arrow : Icons.pause,
                    size: 60,
                  ).paddingAll(8)),
              IconButton(
                  onPressed: () {
                    _resetStopwatch();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.restart_alt_rounded,
                    size: 60,
                  ).paddingAll(8))
            ],
          )
        ],
      ),
    );
  }
}
