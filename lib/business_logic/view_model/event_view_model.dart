import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/upcoming_page_item.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

import 'abstract_view_model.dart';

class EventViewModel extends AbstractViewModel {

  final WebApi _webApi = WebApi();
  EventResponse? _eventResponse;

  EventViewModel();

  EventViewModel.fromEventId(int eventId){
    loadById(eventId);
  }

  EventViewModel.fromPageItem(UpcomingPageItem pageItem){
    _eventResponse = EventResponse(
      event: pageItem.event,
      interested: pageItem.interested,
    );
  }

  EventResponse? get eventResponse => _eventResponse;

  Future<void> addEventInterest( int eventId ) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.addEventInterest(eventId);
      _eventResponse = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> removeEventInterest( int eventId ) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.removeEventInterest(eventId);
      _eventResponse = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }

  Future<void> loadById( int eventId ) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.getEventById(eventId);
      _eventResponse = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }
}
