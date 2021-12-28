import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mustang_viewer/src/utils/next_search_result_intent.dart';
import 'package:mustang_viewer/src/utils/previous_search_result_intent.dart';
import 'package:mustang_viewer/src/utils/app_constants.dart';
import 'package:mustang_viewer/src/utils/app_shortcuts.dart';
import 'package:mustang_viewer/src/utils/app_styles.dart';
import 'package:pretty_json/pretty_json.dart';

class DataView extends StatelessWidget {
  const DataView(
    this.text,
    this.searchText,
    this.onSearchTermChange,
    this.scrollController,
    this.highlightIndices,
    this.indexOfSelectedHighlight,
    this.updateSelectedIndex, {
    Key? key,
  }) : super(key: key);

  final String text;
  final String searchText;
  final void Function(String term) onSearchTermChange;
  final ScrollController scrollController;
  final List<int> highlightIndices;
  final int indexOfSelectedHighlight;
  final void Function(int index) updateSelectedIndex;

  @override
  Widget build(BuildContext context) {
    List<GlobalKey> highlightKeys = List.generate(
      highlightIndices.length,
      (index) => GlobalKey(),
    );

    SchedulerBinding.instance?.addPostFrameCallback(
      (_) {
        if (highlightKeys.isNotEmpty) {
          Scrollable.ensureVisible(
            highlightKeys[indexOfSelectedHighlight].currentContext!,
            alignment: AppStyles.dataViewScrollAlignment,
            duration: const Duration(
              milliseconds: AppStyles.duration500,
            ),
          );
        }
      },
    );

    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        AppShortcuts.arrowUp: NextSearchResultIntent(indexOfSelectedHighlight),
        AppShortcuts.arrowDown:
            PreviousSearchResultIntent(indexOfSelectedHighlight),
      },
      actions: {
        NextSearchResultIntent: CallbackAction(onInvoke: (Intent e) {
          e = e as NextSearchResultIntent;
          updateSelectedIndex(e.nextIndex);
        }),
        PreviousSearchResultIntent: CallbackAction(onInvoke: (Intent e) {
          e = e as PreviousSearchResultIntent;
          updateSelectedIndex(e.previousIndex);
        }),
      },
      child: Column(
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
                suffixIcon: (highlightIndices.isNotEmpty &&
                        searchText.isNotEmpty)
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${highlightIndices.length} ${AppConstants.found}'),
                          IconButton(
                            onPressed: () {
                              updateSelectedIndex(indexOfSelectedHighlight + 1);
                            },
                            icon: const Icon(
                              Icons.arrow_downward,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              updateSelectedIndex(indexOfSelectedHighlight - 1);
                            },
                            icon: const Icon(
                              Icons.arrow_upward,
                            ),
                          ),
                        ],
                      )
                    : null,
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
                          text: highlightSearchTerm(
                            highlightIndices,
                            prettyJson(jsonDecode(text)),
                            searchText,
                            highlightKeys,
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
      ),
    );
  }

  TextSpan highlightSearchTerm(
    List<int> highlightIndices,
    String stringToBeSearched,
    String searchTerm,
    List<GlobalKey> highlightKeys,
  ) {
    const TextStyle _posRes = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.red,
    );
    const TextStyle _negRes = TextStyle(
      color: Colors.white,
      backgroundColor: Colors.transparent,
    );
    if (highlightIndices.isEmpty) {
      return TextSpan(text: stringToBeSearched, style: _negRes);
    }

    List<TextSpan> highlights = [];
    for (int i = 0; i < highlightIndices.length - 1; i++) {
      highlights.addAll([
        TextSpan(
          text: stringToBeSearched.substring(
            highlightIndices.toList()[i],
            highlightIndices.toList()[i] + searchTerm.length,
          ),
          children: [
            WidgetSpan(
              child: SizedBox.fromSize(
                size: Size.zero,
                key: highlightKeys[i],
              ),
            )
          ],
          style: _posRes,
        ),
        TextSpan(
          text: stringToBeSearched.substring(
            highlightIndices.toList()[i] + searchTerm.length,
            highlightIndices.toList()[i + 1],
          ),
          style: _negRes,
        ),
      ]);
    }
    highlights.addAll([
      TextSpan(
        text: stringToBeSearched.substring(
          highlightIndices.last,
          highlightIndices.last + searchTerm.length,
        ),
        children: [
          WidgetSpan(
            child: SizedBox.fromSize(
              size: Size.zero,
              key: highlightKeys[highlightIndices.length - 1],
            ),
          )
        ],
        style: _posRes,
      ),
      TextSpan(
        text: stringToBeSearched.substring(
          highlightIndices.last + searchTerm.length,
          stringToBeSearched.length,
        ),
        style: _negRes,
      ),
    ]);
    TextSpan textSpan = TextSpan(
      style: _negRes,
      text: stringToBeSearched.substring(
        0,
        highlightIndices.first,
      ),
      children: highlights,
    );
    return textSpan;
  }
}
