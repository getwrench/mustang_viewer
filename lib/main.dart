import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/connect/connect_screen.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_routes.dart';

void main() {
  runApp(const MustangViewer());
}

class MustangViewer extends StatelessWidget {
  const MustangViewer({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.mustangViewer,
      home: const ConnectScreen(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    );
  }
}
