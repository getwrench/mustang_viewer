import 'package:flutter/material.dart';

class NextSearchResultIntent extends Intent {
  late final int nextIndex;

  NextSearchResultIntent(int currentIndex) {
    nextIndex = currentIndex - 1;
  }
}
