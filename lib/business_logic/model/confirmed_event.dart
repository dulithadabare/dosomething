class ConfirmedEvent {
  int? id = -1;
  int? creatorId;
  String? activity;
  String? createdTime;
  List<int>? invitedList = [];

  ConfirmedEvent({
    this.id,
    this.creatorId,
    this.createdTime,
    this.activity,
    this.invitedList,
  });

  factory ConfirmedEvent.fromJson(Map<String, dynamic> json) {
    final tagList = json['tagList'] != null ? new List<String>.from((json['tagList'] as List)): <String>[];

    return ConfirmedEvent(
      id: json['id'],
      creatorId: json['creatorId'],
      activity: json['description'],
      createdTime: json['createdTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'description': this.activity,
      'invitedList': this.invitedList,
      'createdTime': DateTime.now().millisecondsSinceEpoch,
    };
  }

  static ConfirmedEvent fromJsonModel(Map<String, dynamic> json) =>
      ConfirmedEvent.fromJson(json);
}
