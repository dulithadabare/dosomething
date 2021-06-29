import 'dart:convert';

class NotificationPageItem {
  final int id;
  final String message;
  final String payload;
  final int timestampUtc;
  final int type;
  final DecodedPayload decodedPayload;

  NotificationPageItem({
    required this.id,
    required this.message,
    required this.payload,
    required this.timestampUtc,
    required this.type,
    required this.decodedPayload,
  });

  factory NotificationPageItem.fromJson(Map<String, dynamic> jsonMap) {
    final payload = jsonMap['payload'];
    final eventNotification = DecodedPayload.fromJson(json.decode(payload));
    return NotificationPageItem(
      id: jsonMap['id'],
      message: jsonMap['message'],
      payload: payload,
      timestampUtc: jsonMap['timestampUtc'],
      type: jsonMap['type'],
      decodedPayload: eventNotification,
    );
  }

  static NotificationPageItem fromJsonModel(Map<String, dynamic> json) => NotificationPageItem.fromJson(json);
}

class DecodedPayload {
  final int eventId;
  final String type;
  final List<int> data;

  DecodedPayload({
    required this.eventId,
    required this.type,
    required this.data,
  });

  factory DecodedPayload.fromJson(Map<String, dynamic> json) {
    final data = json['data'] != null ? List<int>.from(json['data'] as List) : <int>[];
    return DecodedPayload(
      eventId: json['eventId'],
      type: json['type'],
      data: data,
    );
  }

  static DecodedPayload fromJsonModel(Map<String, dynamic> json) => DecodedPayload.fromJson(json);
}