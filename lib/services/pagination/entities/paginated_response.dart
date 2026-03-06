/// Metadata for a paginated API response.
///
/// Contains information about the current page, page size, and total count
/// to enable pagination logic in the UI.
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);

  /// Current page number (1-indexed).
  final int page;

  /// Number of items per page.
  final int pageSize;

  /// Total number of items across all pages.
  final int totalCount;

  /// Creates a copy with updated fields.
  PaginationMeta copyWith({
    int? page,
    int? pageSize,
    int? totalCount,
  }) {
    return PaginationMeta(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  /// Total number of pages available.
  int get totalPages => (totalCount / pageSize).ceil();

  /// Whether there are more pages available after the current page.
  bool get hasMore => page < totalPages;

  /// The next page number.
  int get nextPage => page + 1;
}

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    PaginationMeta(
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      totalCount: (json['total_count'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_count': instance.totalCount,
    };
