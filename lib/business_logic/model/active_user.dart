import 'basic_profile.dart';

class ActivePageItem {
  final BasicProfile user;
  final String activeTime;
  final int timestampUtc;

  ActivePageItem({
    required this.user,
    required this.activeTime,
    required this.timestampUtc,
  });

  factory ActivePageItem.fromJson(Map<String, dynamic> json) {
    return ActivePageItem(
      user: BasicProfile.fromJson(json['user']),
      activeTime: json['activeTime'],
      timestampUtc: json['timestampUtc'],
    );
  }

  static ActivePageItem fromJsonModel(Map<String, dynamic> json) => ActivePageItem.fromJson(json);
}