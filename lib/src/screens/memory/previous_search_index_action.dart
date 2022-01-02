import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.dart';
import 'package:mustang_viewer/src/utils/previous_search_result_intent.dart';

class PreviousSearchIndexAction extends Action<PreviousSearchResultIntent> {
  @override
  Object? invoke(PreviousSearchResultIntent intent) {
    MemoryService().onNavigateModelViewSearchMatches(intent.previousIndex);
  }
}
