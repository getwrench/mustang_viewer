/// [AppTextHighlighter] is used to highlight part of text
class AppTextHighlighter {
  static List<int> findHighlights(
    String stringToBeSearched,
    String searchTerm,
  ) {
    List<int> indexList = [];
    int index = stringToBeSearched.indexOf(searchTerm);
    while (index >= 0 && searchTerm.isNotEmpty) {
      indexList.add(index);
      index = stringToBeSearched.indexOf(searchTerm, index + 1);
    }
    return indexList;
  }
}
