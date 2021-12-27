/// [AppTextHighlighter] is used to highlight part of text
class AppTextHighlighter {
  static Map<int, int> findHighlights(
    String stringToBeSearched,
    String searchTerm,
  ) {
    List<int> startList = [];
    List<int> endList = [];
    int index = stringToBeSearched.indexOf(searchTerm);
    while (index >= 0 && searchTerm.isNotEmpty) {
      startList.add(index);
      index = stringToBeSearched.indexOf(searchTerm, index + 1);
    }

    for (index in startList) {
      endList.add(index + searchTerm.length);
    }
    return Map<int, int>.fromIterables(startList, endList);
  }
}
