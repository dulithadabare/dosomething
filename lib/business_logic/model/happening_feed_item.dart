import 'basic_profile.dart';
import 'confirmed_event.dart';
import 'event.dart';

class HappeningPageItem {
  Event event;
  int activeCount;
  List<BasicProfile> activeFriendList;
  int timestampUtc;

  HappeningPageItem({
    required this.event,
    required this.activeCount,
    required this.activeFriendList,
    required this.timestampUtc,
  });

  factory HappeningPageItem.fromJson(Map<String, dynamic> json) {
    final activeFriendList = json['activeFriendList'] != null ? List<BasicProfile>.from((json['activeFriendList'] as List).map((e) => BasicProfile.fromJson(e))) : <BasicProfile>[];

    return HappeningPageItem(
      event: Event.fromJson(json['event']),
      activeCount: json['activeCount'],
      timestampUtc: json['timestampUtc'],
      activeFriendList: activeFriendList,
    );
  }

  static HappeningPageItem fromJsonModel(Map<String, dynamic> json) => HappeningPageItem.fromJson(json);
}