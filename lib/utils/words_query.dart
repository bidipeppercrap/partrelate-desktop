bool wordsQuery(String keywords, String toQuery) {
  List<String> words = keywords.toLowerCase().trim().split(' ');
  List<String> queries = toQuery.toLowerCase().trim().split(' ');

  return words.every((word) => queries.any((q) => q.contains(word)));
}
