class BasicProfile {
  final int userId;
  final String? displayName;

  BasicProfile({
    required this.userId,
    this.displayName,
  });

  factory BasicProfile.fromJson(Map<String, dynamic> json) {
    return BasicProfile(
      userId: json['userId'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic>? toJson(){
    return {
      'userId' : this.userId,
      'displayName' : this.displayName,
    };
  }

  static BasicProfile fromJsonModel(Map<String, dynamic> json) => BasicProfile.fromJson(json);
}