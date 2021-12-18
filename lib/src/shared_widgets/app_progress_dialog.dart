import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/shared_widgets/app_progress_indicator.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class AppProgressDialog extends StatelessWidget {
  const AppProgressDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppStyles.padding4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyles.radius4),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppStyles.height150,
        ),
        child: const AppProgressIndicator(),
      ),
    );
  }
}
