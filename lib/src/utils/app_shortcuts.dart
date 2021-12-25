import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcuts {
  static final LogicalKeySet _arrowUp = LogicalKeySet(
    LogicalKeyboardKey.arrowUp,
  );
  static final LogicalKeySet _arrowDown = LogicalKeySet(
    LogicalKeyboardKey.arrowDown,
  );
  static final LogicalKeySet _arrowLeft = LogicalKeySet(
    LogicalKeyboardKey.arrowLeft,
  );
  static final LogicalKeySet _arrowRight = LogicalKeySet(
    LogicalKeyboardKey.arrowRight,
  );

  static Map<ShortcutActivator, Intent> getShortCuts() {
    return {
      _arrowUp: ArrowUpKeyPressIntent(),
      _arrowDown: ArrowDownKeyPressIntent(),
      _arrowLeft: ArrowLeftKeyPressIntent(),
      _arrowRight: ArrowRightKeyPressIntent(),
    };
  }
}

class ArrowUpKeyPressIntent extends Intent {}
class ArrowDownKeyPressIntent extends Intent {}
class ArrowLeftKeyPressIntent extends Intent {}
class ArrowRightKeyPressIntent extends Intent {}