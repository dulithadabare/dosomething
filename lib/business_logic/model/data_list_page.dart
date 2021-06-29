class DataListPage<T> {
  final String? nextPageKey;
  final List<T> itemList;

  DataListPage({
    this.nextPageKey,
    required this.itemList,
  });

  factory DataListPage.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    return DataListPage(
      nextPageKey: json['nextPageKey'],
      itemList: new List<T>.from((json['itemList'] as List).map((e) => fromJsonModel(e))),
    );
  }

  static DataListPage<T> fromJsonModel<T>(Map<String, dynamic> json, Function fromJsonModel) => DataListPage<T>.fromJson(json, fromJsonModel);
}