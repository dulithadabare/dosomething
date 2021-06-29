
import 'basic_profile.dart';

class InterestedFriendPageItem {
  final BasicProfile user;
  bool peekSent;
  bool peekBack;
  final int timestampUtc;

  InterestedFriendPageItem({
    required this.user,
    required this.peekSent,
    required this.peekBack,
    required this.timestampUtc,
  });

  factory InterestedFriendPageItem.fromJson(Map<String, dynamic> json) {
    return InterestedFriendPageItem(
      user: BasicProfile.fromJson(json['user']),
      peekSent: json['peekSent'],
      peekBack: json['peekBack'],
      timestampUtc: json['timestampUtc'],
    );
  }

  static InterestedFriendPageItem fromJsonModel(Map<String, dynamic> json) => InterestedFriendPageItem.fromJson(json);
}