import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:makaya/main.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xDD000000);
  static const Color loginGradientEnd = const Color.fromRGBO(43, 87, 126, 1);


  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}