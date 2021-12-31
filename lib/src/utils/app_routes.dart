import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/connect/connect_screen.dart';
import 'package:mustang_viewer/src/screens/diff/diff_screen.dart';
import 'package:mustang_viewer/src/screens/memory/memory_screen.dart';

class AppRoutes {
  static const String connect = '/connect';
  static const String memory = '/memory';
  static const String diff = '/diff';

  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.connect:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ConnectScreen(),
          transitionDuration: Duration.zero,
        );
      case AppRoutes.diff:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DiffScreen(),
          transitionDuration: Duration.zero,
        );
      case AppRoutes.memory:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MemoryScreen(),
          transitionDuration: Duration.zero,
        );
    }
  }
}
