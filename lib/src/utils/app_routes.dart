import 'package:flutter/cupertino.dart';
import 'package:mustang_viewer/src/screens/connect/connect_screen.dart';
import 'package:mustang_viewer/src/screens/memory/memory_screen.dart';

class AppRoutes {
  static const String connect = '/connect';
  static const String memory = '/memory';

  static final Map<String, WidgetBuilder> routeBuilders = {
    AppRoutes.connect: (BuildContext _) => const ConnectScreen(),
    AppRoutes.memory: (BuildContext _) => const MemoryScreen(),
  };
}
