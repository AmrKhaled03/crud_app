import 'package:flutter/material.dart';

extension NumTxt on num {
  SizedBox get gap => SizedBox(
        height: toDouble(),
        width: toDouble(),
      );
}
