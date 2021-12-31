import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    required this.buttonIcon,
    required this.tooltipMessage,
    required this.onPress,
    this.active = false,
  }) : super(key: key);

  final Icon buttonIcon;

  final String tooltipMessage;

  final bool active;

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: SizedBox(
        height: AppStyles.width50,
        child: MaterialButton(
          onPressed: onPress,
          child: buttonIcon,
          color:
              active ? Colors.black45 : null,
        ),
      ),
    );
  }
}
