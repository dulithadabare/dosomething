import 'package:dosomething/business_logic/model/current_activity.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

import 'abstract_view_model.dart';

class CurrentActivityViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();

  CurrentActivity? _activeEvent;

  CurrentActivity? get activeEvent => _activeEvent;

  set activeEvent(CurrentActivity? value) {
    _activeEvent = value;

    notifyListeners();
  }

  Future<void> load() async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.getCurrentActivity();
      _activeEvent = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> joinEvent(int eventId, int userId) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.joinEvent(eventId);
      _activeEvent = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> leaveEvent(int eventId, int userId) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.leaveEvent(eventId);
      _activeEvent = CurrentActivity( userId: userId, eventId: -1 );
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

}
