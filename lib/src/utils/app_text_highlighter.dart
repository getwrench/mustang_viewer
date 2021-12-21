import 'package:flutter/material.dart';

/// [AppTextHighlighter] is used to highlight part of text
class AppTextHighlighter {
  static const TextStyle _posRes = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.red,
  );
  static const TextStyle _negRes = TextStyle(
    color: Colors.white,
    backgroundColor: Colors.transparent,
  );

  /// [searchMatch] is used to highlight the subtext in [stringToBeSearched]
  /// that matched [search] string
  /// Input: String to be searched, search string
  /// Output: TextSpan with the substring highlighted
  static TextSpan searchMatch(String stringToBeSearched, String search) {
    if (search.isEmpty) {
      return TextSpan(text: stringToBeSearched, style: _negRes);
    }
    String refinedMatch = stringToBeSearched.toLowerCase();
    String refinedSearch = search.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: _posRes,
          text: stringToBeSearched.substring(0, refinedSearch.length),
          children: [
            searchMatch(
              stringToBeSearched.substring(
                refinedSearch.length,
              ),
              search,
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(text: stringToBeSearched, style: _posRes);
      } else {
        return TextSpan(
          style: _negRes,
          text: stringToBeSearched.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
                stringToBeSearched.substring(
                  refinedMatch.indexOf(refinedSearch),
                ),
                search),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: stringToBeSearched, style: _negRes);
    }
    return TextSpan(
      text:
          stringToBeSearched.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: _negRes,
      children: [
        searchMatch(
          stringToBeSearched.substring(
            refinedMatch.indexOf(refinedSearch),
          ),
          search,
        ),
      ],
    );
  }
}
