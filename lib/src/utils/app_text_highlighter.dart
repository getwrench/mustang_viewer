/// [AppTextHighlighter] is used to highlight part of text
class AppTextHighlighter {
  static List<int> findHighlights(
    String stringToBeSearched,
    String searchTerm,
  ) {
    Iterable<RegExpMatch> matches = RegExp(searchTerm).allMatches(
      stringToBeSearched,
    );
    List<int> occurences = [];
    for (RegExpMatch match in matches) {
      occurences.add(match.start);
    }
    return occurences;
  }
}
