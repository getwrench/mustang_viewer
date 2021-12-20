import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';

class EventText extends StatelessWidget {
  const EventText({
    Key? key,
    required this.rowNum,
    required this.ts,
    required this.modelName,
    required this.selected,
  }) : super(key: key);

  final int rowNum;
  final String ts;
  final String modelName;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '#$rowNum ',
            style: const TextStyle(
              fontSize: AppStyles.font12,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: '$ts ',
            style: const TextStyle(
              fontSize: AppStyles.font12,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: modelName,
            style: TextStyle(
              fontSize: AppStyles.font12,
              color: selected
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).textTheme.bodyText1!.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
