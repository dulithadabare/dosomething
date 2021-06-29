class UserProfile {
  final int? userId;
  final String? firebaseUid;
  final String? facebookId;
  final String? displayName;
  final String? email;

  UserProfile({
    this.userId,
    this.firebaseUid,
    this.facebookId,
    this.displayName,
    this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      firebaseUid: json['firebaseUid'],
      facebookId: json['facebookId'],
      displayName: json['displayName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'userId' : this.userId,
      'firebaseUid' : this.firebaseUid,
      'facebookId' : this.facebookId,
      'displayName' : this.displayName,
      'email' : this.email,
    };
  }

  static UserProfile fromJsonModel(Map<String, dynamic> json) => UserProfile.fromJson(json);
}