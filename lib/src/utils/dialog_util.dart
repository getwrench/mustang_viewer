import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_dialog.dart';

class DialogUtil {
  static Future<void> show(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: const AppProgressDialog(),
      ),
    );
  }

  static Future<void> showMessage(BuildContext context, String message) async {
    SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
