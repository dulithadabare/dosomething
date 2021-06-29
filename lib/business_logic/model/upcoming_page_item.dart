
import 'event.dart';

class UpcomingPageItem {
  final Event event;
  bool? interested;
  int timestampUtc;

  UpcomingPageItem({
    required this.event,
    this.interested,
    required this.timestampUtc,
  });

  factory UpcomingPageItem.fromJson(Map<String, dynamic> json) {
    return UpcomingPageItem(
      interested: json['interested'] ,
      timestampUtc: json['timestampUtc'] ,
      event: Event.fromJson(json['event']),
    );
  }

  static UpcomingPageItem fromJsonModel(Map<String, dynamic> json) => UpcomingPageItem.fromJson(json);

}