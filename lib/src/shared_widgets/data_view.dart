import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
import 'package:pretty_json/pretty_json.dart';

class DataView extends StatelessWidget {
  const DataView(
    this.text,
    this.searchText,
    this.onSearchTermChange,
    this.scrollController, {
    Key? key,
  }) : super(key: key);

  final String text;
  final String searchText;
  final void Function(String term) onSearchTermChange;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(AppStyles.padding8),
          child: Text(
            AppConstants.dataView,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppStyles.padding8),
          child: TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppConstants.search,
            ),
            onChanged: onSearchTermChange,
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
                      child: RichText(
                        textScaleFactor: AppStyles.dataTextScaleFactor,
                        text: AppTextHighlighter.searchMatch(
                          prettyJson(jsonDecode(text)),
                          searchText,
                        ),
                      ),
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
