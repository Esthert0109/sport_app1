import 'dart:async';
import 'package:flutter/material.dart';

class Countdown {
  int seconds;
  Timer? timer;

  Countdown(this.seconds);

  void start(Function(int) onTick, VoidCallback onDone) {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds < 0) {
        timer.cancel();
        onDone();
      } else {
        onTick(seconds);
      }
    });
  }

  void cancel() {
    timer?.cancel();
  }
}
