class CurrentActivity {
  int? userId;
  int? eventId;
  String? updatedTime;

  CurrentActivity({
    this.userId,
    this.eventId,
    this.updatedTime
  });

  factory CurrentActivity.fromJson(Map<String, dynamic> json) {
    return CurrentActivity(
      userId: json['userId'],
      eventId: json['eventId'],
      updatedTime: json['updatedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': this.userId,
      'eventId': this.eventId,
      'updatedTime': DateTime.now().millisecondsSinceEpoch,
    };
  }

  static CurrentActivity fromJsonModel(Map<String, dynamic> json) => CurrentActivity.fromJson(json);
}