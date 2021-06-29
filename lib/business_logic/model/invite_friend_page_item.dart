import 'package:dosomething/business_logic/model/basic_profile.dart';

class InviteFriendPageItem {
  final BasicProfile user;
  bool invited = false;

  InviteFriendPageItem({
    required this.user,
  });

  factory InviteFriendPageItem.fromJson(Map<String, dynamic> json) {
    return InviteFriendPageItem(
      user: BasicProfile.fromJson(json['user']),
    );
  }

  static InviteFriendPageItem fromJsonModel(Map<String, dynamic> json) => InviteFriendPageItem.fromJson(json);
}