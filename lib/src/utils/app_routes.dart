import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/connect/connect_screen.dart';
import 'package:mustang_viewer/src/screens/difference/difference_screen.dart';
import 'package:mustang_viewer/src/screens/memory/memory_screen.dart';

class AppRoutes {
  static const String connect = '/connect';
  static const String memory = '/memory';
  static const String difference = '/difference';

  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.difference:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DifferenceScreen(),
          transitionDuration: Duration.zero,
        );
      case AppRoutes.memory:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MemoryScreen(),
          transitionDuration: Duration.zero,
        );
      case AppRoutes.connect:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ConnectScreen(),
          transitionDuration: Duration.zero,
        );
    }
  }
}
