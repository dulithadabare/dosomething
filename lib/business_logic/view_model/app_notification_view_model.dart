import 'package:dosomething/business_logic/model/current_activity.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import 'abstract_view_model.dart';

class AppNotificationViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();

  bool _newNotificationAvailable = false;
  Soundpool? _pool;
  int? soundId;

  bool get newNotificationAvailable => _newNotificationAvailable;

  set newNotificationAvailable(bool value) {
    _newNotificationAvailable = value;

    notifyListeners();
  }


  AppNotificationViewModel(){
    read();
    loadSoundool();
  }

  Future<void> check() async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.getCurrentActivity();
      // _activeEvent = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> initializeMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      print('Requesting Permission');
      settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // Get the token each time the application loads
      final token = await FirebaseMessaging.instance.getToken();

      // Save the initial token to the database
      await saveTokenToDatabase(token);

      // Any time the token refreshes, store this in the database too.
      FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
      registerForegroundListeners();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> saveTokenToDatabase(String? token) async {
    print('Saving token to database $token');
    try {
      if(token != null) await _webApi.saveUserToken(token);
    } on FetchDataException catch (e) {
      print(e.toString());
    }
  }

  void registerForegroundListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        newNotificationAvailable = true;
        if(_pool != null && soundId != null ) _pool!.play(soundId!);

        print('Message also contained a notification: ${message.notification!.body}');
      }
    });
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'new_notifications';
    newNotificationAvailable = prefs.getBool(key) ?? false;
    print('read new_notifications: $newNotificationAvailable');
  }

  save(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'new_notifications';
    prefs.setBool(key, value);
    print('saved new_notifications $value');
    read();
  }

  loadSoundool() async {
    _pool = Soundpool.fromOptions(options: SoundpoolOptions(
        streamType: StreamType.notification
    ));
    soundId = await rootBundle.load('assets/notification.wav').then((ByteData soundData) {
      return _pool!.load(soundData);
    });
  }
}
