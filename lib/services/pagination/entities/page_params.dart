class PageParams {
  const PageParams({this.page = 1, this.pageSize = 20});

  factory PageParams.fromJson(Map<String, dynamic> json) =>
      _$PageParamsFromJson(json);

  final int page;
  final int pageSize;

  PageParams copyWith({int? page, int? pageSize}) {
    return PageParams(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  PageParams nextPage() {
    return PageParams(page: page + 1, pageSize: pageSize);
  }

  PageParams firstPage() {
    return PageParams(pageSize: pageSize);
  }

  Map<String, dynamic> toJson() => _$PageParamsToJson(this);
}

PageParams _$PageParamsFromJson(Map<String, dynamic> json) => PageParams(
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$PageParamsToJson(PageParams instance) =>
    <String, dynamic>{'page': instance.page, 'page_size': instance.pageSize};
