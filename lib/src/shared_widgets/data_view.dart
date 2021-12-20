import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:pretty_json/pretty_json.dart';

class DataView extends StatelessWidget {
  const DataView(
    this.text,
    this.scrollController, {
    Key? key,
  }) : super(key: key);

  final String text;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.dataView,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.padding8),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(prettyJson(jsonDecode(text))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
