import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/happening_feed_item.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

import 'abstract_view_model.dart';

class ConfirmedEventViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();

  EventResponse? _eventResponse;

  EventResponse? get eventResponse => _eventResponse;

  ConfirmedEventViewModel.fromEventId(int eventId){
    loadById(eventId);
  }

  ConfirmedEventViewModel.fromPageItem(HappeningPageItem pageItem){
    _eventResponse = EventResponse(
      event: pageItem.event,
    );
  }

  Future<void> loadById( int eventId ) async {
    setStatus(ViewModelStatus.busy);
    try {
      final data = await _webApi.getConfirmedEventById(eventId);
      _eventResponse = data[0];
      setStatus(ViewModelStatus.idle);
    } on FetchDataException catch (e) {
      print(e.toString());
      setStatus(ViewModelStatus.error);
    }
  }
}
