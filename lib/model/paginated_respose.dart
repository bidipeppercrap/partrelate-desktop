class PaginatedResponse {
  const PaginatedResponse({required this.totalPages, required this.data});

  final int totalPages;
  final List<dynamic> data;

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'totalPages': int totalPages, 'data': List<dynamic> data} =>
        PaginatedResponse(totalPages: totalPages, data: data),
      _ => throw const FormatException(
          'Failed to load Paginated Response from JSON')
    };
  }
}
