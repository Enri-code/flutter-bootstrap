class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);

  final int page;
  final int pageSize;
  final int totalCount;

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

  int get totalPages => (totalCount / pageSize).ceil();
  bool get hasMore => page < totalPages;
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
