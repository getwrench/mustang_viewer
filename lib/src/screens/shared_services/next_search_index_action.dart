import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/next_search_result_intent.dart';

class NextSearchIndexAction extends Action<NextSearchResultIntent> {
  NextSearchIndexAction(
    this.onNavigateModelViewSearchMatches,
  );

  final void Function(int) onNavigateModelViewSearchMatches;

  @override
  Object? invoke(NextSearchResultIntent intent) {
    onNavigateModelViewSearchMatches(intent.nextIndex);
  }
}
