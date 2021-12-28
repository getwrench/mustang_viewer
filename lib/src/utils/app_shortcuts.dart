import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcuts {
  static SingleActivator arrowUp = const SingleActivator(
    LogicalKeyboardKey.arrowUp,
  );
  static SingleActivator arrowDown = const SingleActivator(
    LogicalKeyboardKey.arrowDown,
  );
  static SingleActivator arrowLeft = const SingleActivator(
    LogicalKeyboardKey.arrowLeft,
  );
  static SingleActivator arrowRight = const SingleActivator(
    LogicalKeyboardKey.arrowRight,
  );
}
