class SearchResult<T> {
  List<T> items = [];
  int? totalCount;

  SearchResult({
    this.items = const [],
    this.totalCount,
  });
}