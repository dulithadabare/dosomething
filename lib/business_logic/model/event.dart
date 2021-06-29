class Event {
  int? id = -1;
  int? creatorId;
  String activity = '';
  String? createdTime;

  Event({
    this.id,
    this.creatorId,
    required this.activity,
    this.createdTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      creatorId: json['creatorId'],
      activity: json['description'],
      createdTime: json['createdTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'userId': this.creatorId,
      'description': this.activity,
      'createdTime': DateTime.now().millisecondsSinceEpoch,
    };
  }

  static Event fromJsonModel(Map<String, dynamic> json) => Event.fromJson(json);
}
