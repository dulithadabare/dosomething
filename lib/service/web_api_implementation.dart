import 'dart:convert';
import 'dart:io';
import 'package:dosomething/business_logic/model/active_user.dart';
import 'package:dosomething/business_logic/model/current_activity.dart';
import 'package:dosomething/business_logic/model/basic_response.dart';
import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:dosomething/business_logic/model/happening_feed_item.dart';
import 'package:dosomething/business_logic/model/confirmed_event.dart';
import 'package:dosomething/business_logic/model/event.dart';
import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/interested_friend_page_item.dart';
import 'package:dosomething/business_logic/model/invite_friend_page_item.dart';
import 'package:dosomething/business_logic/model/upcoming_page_item.dart';
import 'package:dosomething/business_logic/model/user_profile.dart';
import 'package:dosomething/business_logic/model/notification_page_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'api_helper.dart';

class WebApi {
  // final String _baseUrl = "agile-atoll-70076.herokuapp.com";
  final String _baseUrl = "localhost:8080";

  FirebaseAuth get auth => FirebaseAuth.instance;

  Uri createURI(String baseURL,  String resource, [Map<String, dynamic>? queryParameters] ) {
    return Uri.http(_baseUrl, resource, queryParameters);
  }

  Future<List<UserProfile>> createUser(UserProfile newUser) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();
      final response = await http.post(
        createURI(_baseUrl, 'users',),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(newUser),
      );
      final basicResponse = BasicResponse<UserProfile>.fromJson(_returnJsonFromResponse(response), UserProfile.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<UserProfile>> getUser() async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();
      final response = await http.get(
        createURI(_baseUrl, 'users',),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      final jsonMap = _returnJsonFromResponse(response);
      final basicResponse = BasicResponse<UserProfile>.fromJson(jsonMap, UserProfile.fromJsonModel);

      if(basicResponse.status == -1) {
        throw FetchDataException(basicResponse.message);
      }

      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<HappeningPageItem>>> getHappeningFeedPage( String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'now', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = HappeningBasicResponse.fromJson( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<UpcomingPageItem>>> getUpcomingFeedPage( String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'pops', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = UpcomingBasicResponse.fromJson( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> getEventById(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'pops/$eventId'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );
      print('event $eventId  ${utf8.decode(response.bodyBytes)}');
      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;

    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> getConfirmedEventById(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'now/$eventId'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print('Confirmed Event $eventId ${response.body}');

      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;

    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<InterestedFriendPageItem>>> getInterestedFriendFeedPage( int eventId, String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'pops/$eventId/interested', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = InterestedFriendBasicResponse.fromJson( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<InviteFriendPageItem>>> getFriendPage(String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'users/friends', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = InviteFriendBasicResponse.fromJson( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<CurrentActivity>> joinEvent(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.post(
        createURI(_baseUrl, 'now/$eventId/active'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      final basicResponse = BasicResponse<CurrentActivity>.fromJson( _returnJsonFromResponse(response), CurrentActivity.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<CurrentActivity>> leaveEvent(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.delete(
        createURI(_baseUrl, 'now/$eventId/active'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      final basicResponse = BasicResponse<CurrentActivity>.fromJson( _returnJsonFromResponse(response), CurrentActivity.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<int>> getFriendCount() async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'settings/friend-count'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print('friend count ${response.body}');

      final basicResponse = BasicResponse<int>.fromJson( _returnJsonFromResponse(response), (e) => e);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<CurrentActivity>> getCurrentActivity() async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'users/current-activity'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
      );

      print('Current Activity ${response.body}');

      final basicResponse = BasicResponse<CurrentActivity>.fromJson( _returnJsonFromResponse(response), CurrentActivity.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<ActivePageItem>>> getActivePage( int eventId, String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'now/$eventId/active', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = ActiveBasicResponse.fromJson( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> createEvent(Event event) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.post(
        createURI(_baseUrl, 'pops'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event),
      );

      print('Created Event ${response.body}');

      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> createConfirmedEvent(ConfirmedEvent event) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.post(
        createURI(_baseUrl, 'now'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(event),
      );
      print( response.body );
      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> addEventInterest(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.post(
        createURI(_baseUrl, 'pops/$eventId/interested',),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'Content-Type': 'application/json',
        },
      );

      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> removeEventInterest(int eventId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.delete(
        createURI(_baseUrl, 'pops/$eventId/interested'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<EventResponse>> peek(int eventId, int friendId) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.post(
        createURI(_baseUrl, 'pops/$eventId/peek/$friendId'),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
          'X-USER-TIMEZONE': 'Asia/Colombo',
        },
      );

      final basicResponse = BasicResponse<EventResponse>.fromJson( _returnJsonFromResponse(response), EventResponse.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<DataListPage<NotificationPageItem>>> getAppNotifications( String? pageKey ) async {
    try {
      final firebaseIdToken = await auth.currentUser!.getIdToken();

      final response = await http.get(
        createURI(_baseUrl, 'notifications', {
          "pageKey" : pageKey,
        }),
        headers: <String, String>{
          'Authorization': 'Bearer $firebaseIdToken',
        },
      );

      print(response.body);

      final basicResponse = BasicResponse<DataListPage<NotificationPageItem>>.fromJsonAppNotification( _returnJsonFromResponse(response), DataListPage.fromJsonModel);
      return basicResponse.data;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  dynamic _returnJsonFromResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        // print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
