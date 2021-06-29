import 'package:dosomething/business_logic/model/event.dart';
import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

import 'abstract_view_model.dart';

class CreateEventViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();
  String description = '';
  bool _enabled = false;

  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;

    notifyListeners();
  }

  Future<ApiResponse<EventResponse>> createEvent( ) async {
    setStatus(ViewModelStatus.busy);
    Event event = Event(activity: description );
    try {
      final data = await _webApi.createEvent(event);
      setStatus(ViewModelStatus.idle);
      return ApiResponse.completed('Loaded Event', data[0]);
    } on FetchDataException catch (e) {
      print(e);
      setStatus(ViewModelStatus.error);
      return ApiResponse.error(e.toString());
    }
  }
}