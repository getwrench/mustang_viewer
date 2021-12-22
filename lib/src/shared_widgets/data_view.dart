import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:mustang_viewer/src/utils/app_text_highlighter.dart';
import 'package:pretty_json/pretty_json.dart';

List<GlobalKey> highlightKeys = [];

class DataView extends StatelessWidget {
  const DataView(
    this.text,
    this.searchText,
    this.onSearchTermChange,
    this.scrollController,
    this.selectedHighlight,
    this.highlightIndex, {
    Key? key,
  }) : super(key: key);

  final String text;
  final String searchText;
  final void Function(String term) onSearchTermChange;
  final ScrollController scrollController;
  final void Function(int index) selectedHighlight;
  final int highlightIndex;

  @override
  Widget build(BuildContext context) {
    highlightKeys = [];
    SchedulerBinding.instance?.addPostFrameCallback(
      (_) {
        if (highlightKeys.isNotEmpty) {
          BuildContext highlightContext =
              highlightKeys[highlightIndex].currentContext!;
          Scrollable.ensureVisible(
            highlightContext,
            alignment: AppStyles.scrollAlignment,
            duration: const Duration(
              milliseconds: AppConstants.milliSec500,
            ),
          );
        } else {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(
              milliseconds: AppConstants.milliSec500,
            ),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
    );

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
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: AppConstants.search,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (highlightKeys.isNotEmpty) {
                        if (highlightIndex + 1 < highlightKeys.length) {
                          selectedHighlight(highlightIndex + 1);
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_downward,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (highlightKeys.isNotEmpty) {
                        if (highlightIndex - 1 >= 0) {
                          selectedHighlight(highlightIndex - 1);
                        }
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_upward,
                    ),
                  )
                ],
              ),
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
                          _addHighlightKey,
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

  void _addHighlightKey(GlobalKey key) {
    highlightKeys.add(key);
  }
}
