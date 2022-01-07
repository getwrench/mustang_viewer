import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/utils/previous_search_result_intent.dart';

class PreviousSearchIndexAction extends Action<PreviousSearchResultIntent> {
  PreviousSearchIndexAction(
    this.onNavigateModelViewSearchMatches,
  );

  final void Function(int) onNavigateModelViewSearchMatches;

  @override
  Object? invoke(PreviousSearchResultIntent intent) {
    onNavigateModelViewSearchMatches(intent.previousIndex);
  }
}
