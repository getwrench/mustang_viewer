import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.dart';
import 'package:mustang_viewer/src/utils/previous_search_result_intent.dart';

class PreviousSearchIndexAction extends Action<Intent> {
  @override
  Object? invoke(Intent intent) {
    intent = intent as PreviousSearchResultIntent;
    MemoryService().updateSelectedHighlight(intent.previousIndex);
  }
}
