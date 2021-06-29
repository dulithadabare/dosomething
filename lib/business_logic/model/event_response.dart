import 'event.dart';

class EventResponse {
  final Event event;
  bool? creatorFriend;
  bool? invited;
  bool? interested;

  EventResponse({
    required this.event,
    this.creatorFriend,
    this.invited,
    this.interested,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      creatorFriend: json['creatorFriend'],
      invited: json['invited'],
      interested: json['interested'],
      event: Event.fromJson(json['event']),
    );
  }

  static EventResponse fromJsonModel(Map<String, dynamic> json) => EventResponse.fromJson(json);

}