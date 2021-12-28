import 'package:flutter/material.dart';
import 'package:mustang_viewer/src/screens/memory/memory_service.dart';
import 'package:mustang_viewer/src/utils/next_search_result_intent.dart';

class NextSearchIndexAction extends Action<Intent> {

  @override
  Object? invoke(Intent intent) {
    intent = intent as NextSearchResultIntent;
    MemoryService().updateSelectedHighlight(intent.nextIndex);
  }
}