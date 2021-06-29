import 'package:dosomething/service/api_helper.dart';
import 'package:flutter/foundation.dart';

import 'active_user.dart';
import 'notification_page_item.dart';
import 'data_list_page.dart';
import 'friend_feed_item.dart';
import 'happening_feed_item.dart';
import 'interested_friend_page_item.dart';
import 'invite_friend_page_item.dart';
import 'upcoming_page_item.dart';

class BasicResponse<T> {
  final int status;
  final String message;
  final List<T> data;

  BasicResponse({this.status = -1, this.message = 'ERROR', this.data = const []});

  factory BasicResponse.fromJsonNoData(Map<String, dynamic> json) {
    return BasicResponse(
      status: json['status'],
      message: json['message'],
      data: [],
    );
  }

  factory BasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if( status == -1 ) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return BasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<T>.from((json['data'] as List).map((e) => fromJsonModel(e))),
    );
  }

  factory BasicResponse.fromJsonAppNotification(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if( status == -1 ) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return BasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<T>.from((json['data'] as List).map((e) => fromJsonModel<NotificationPageItem>(e, NotificationPageItem.fromJsonModel))),
    );
  }

  factory BasicResponse.fromJsonUpcoming(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if( status == -1 ) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return BasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<T>.from((json['data'] as List).map((e) => fromJsonModel<UpcomingPageItem>(e, UpcomingPageItem.fromJsonModel))),
    );
  }
}

class UpcomingBasicResponse extends BasicResponse<DataListPage<UpcomingPageItem>> {

  UpcomingBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory UpcomingBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return UpcomingBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<UpcomingPageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<UpcomingPageItem>(e, UpcomingPageItem.fromJsonModel))),
    );
  }
}

class HappeningBasicResponse extends BasicResponse<DataListPage<HappeningPageItem>> {

  HappeningBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory HappeningBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return HappeningBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<HappeningPageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<HappeningPageItem>(e, HappeningPageItem.fromJsonModel))),
    );
  }
}

class InterestedFriendBasicResponse extends BasicResponse<DataListPage<InterestedFriendPageItem>> {

  InterestedFriendBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory InterestedFriendBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return InterestedFriendBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<InterestedFriendPageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<InterestedFriendPageItem>(e, InterestedFriendPageItem.fromJsonModel))),
    );
  }
}

class InviteFriendBasicResponse extends BasicResponse<DataListPage<InviteFriendPageItem>> {

  InviteFriendBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory InviteFriendBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return InviteFriendBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<InviteFriendPageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<InviteFriendPageItem>(e, InviteFriendPageItem.fromJsonModel))),
    );
  }
}

class FriendBasicResponse extends BasicResponse<DataListPage<FriendPageItem>> {

  FriendBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory FriendBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return FriendBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<FriendPageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<FriendPageItem>(e, FriendPageItem.fromJsonModel))),
    );
  }
}

class ActiveBasicResponse extends BasicResponse<DataListPage<ActivePageItem>> {

  ActiveBasicResponse({status, message, data}) : super( status: status, message: message, data: data );

  factory ActiveBasicResponse.fromJson(Map<String, dynamic> json, Function fromJsonModel) {
    final status = json['status'];
    final message = json['message'];
    if (status == -1) {
      throw FetchDataException(
          'Error occurred while Communication with Server : $message');
    }

    return ActiveBasicResponse(
      status: json['status'],
      message: json['message'],
      data: new List<DataListPage<ActivePageItem>>.from((json['data'] as List).map((e) =>
          fromJsonModel<ActivePageItem>(e, ActivePageItem.fromJsonModel))),
    );
  }
}
