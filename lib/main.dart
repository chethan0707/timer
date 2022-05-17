import 'dart:async';

import 'package:flutter/material.dart';

void main(List<String> args) {
  return runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  bool isTurned = false;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  cancelTimer({bool reset = true}) {
    setState(() {
      if (reset) {
        seconds = maxSeconds;
        timer?.cancel();
        return;
      }
    });
    setState(() {
      timer?.cancel();
    });
  }

  startTimer({bool reset = true}) {
    if (reset) {
      seconds = maxSeconds;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        cancelTimer(reset: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.amberAccent],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.amberAccent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  value: seconds / maxSeconds,
                  color: Colors.cyanAccent.shade700,
                  backgroundColor: Colors.blueGrey,
                  strokeWidth: 10,
                ),
                Center(
                  child: Text(
                    seconds.toString(),
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ]),
            ),
            const SizedBox(
              height: 40,
            ),
            buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;
    String txt = isRunning ? 'Pause' : 'Resume';
    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(primary: Colors.cyanAccent[700]),
                onPressed: () {
                  if (isRunning) {
                    isTurned = false;
                    cancelTimer(reset: false);
                  } else {
                    isTurned = false;
                    startTimer(reset: false);
                  }
                },
                child: Text(
                  txt,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.cyanAccent[700]),
                  onPressed: () {
                    isTurned = false;
                    cancelTimer(reset: true);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.cyanAccent[700]),
            onPressed: () {
              if (seconds == 0) {
                startTimer(reset: true);
              } else if (!isTurned) {
                isTurned = true;
                startTimer(reset: false);
              }
            },
            child: const Text(
              'Start Timer',
              style: TextStyle(color: Colors.black),
            ));
  }
}
