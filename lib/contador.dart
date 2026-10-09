import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _CountdownTo1415 extends StatefulWidget {
  @override
  _CountdownTo1415State createState() => _CountdownTo1415State();
  int getSecondsRemaining() {
    return _CountdownTo1415State()._secondsRemaining;
  }
}

class _CountdownTo1415State extends State<_CountdownTo1415> {
  late Timer _timer;
  late Duration _timeUntil1415;
  late int _secondsRemaining =
      0; // Agregar variable para almacenar los segundos restantes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    DateTime now = DateTime.now();
    DateTime fourteenFifteenToday =
        DateTime(now.year, now.month, now.day, 19, 15);
    DateTime fourteenFifteenTomorrow =
        fourteenFifteenToday.add(Duration(days: 1));

    if (now.isBefore(fourteenFifteenToday)) {
      _timeUntil1415 = fourteenFifteenToday.difference(now);
    } else {
      _timeUntil1415 = fourteenFifteenTomorrow.difference(now);
    }

    _secondsRemaining =
        _timeUntil1415.inSeconds; // Almacenar los segundos restantes

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeUntil1415.inSeconds > 0) {
            _timeUntil1415 -= Duration(seconds: 1);
            _secondsRemaining =
                _timeUntil1415.inSeconds; // Actualizar los segundos restantes
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      right: -9,
      child: Container(
        width: 100,
        child: Text(
          _formatDuration(_timeUntil1415),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontFamily: 'Sarpanch'),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  // Método público para obtener los segundos restantes
  int getSecondsRemaining() {
    return _secondsRemaining;
  }
}
