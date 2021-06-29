import 'basic_profile.dart';

class FriendPageItem {
  final BasicProfile? user;

  FriendPageItem({
    this.user,
  });

  factory FriendPageItem.fromJson(Map<String, dynamic> json) {
    return FriendPageItem(
      user: BasicProfile.fromJson(json['user']),
    );
  }

  static FriendPageItem fromJsonModel(Map<String, dynamic> json) => FriendPageItem.fromJson(json);
}