import 'package:flutter/material.dart';

class PreviousSearchResultIntent extends Intent {
  late final int previousIndex;

  PreviousSearchResultIntent(int currentIndex) {
    previousIndex = currentIndex + 1;
  }
}
