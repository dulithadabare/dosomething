import 'package:dosomething/business_logic/model/confirmed_event.dart';
import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/invite_friend_page_item.dart';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

import 'abstract_view_model.dart';

class CreateConfirmedEventViewModel extends AbstractViewModel {
  final WebApi _webApi = WebApi();
  bool _enabled = false;
  String description = '';
  Set<int> invites = {};

  bool get enabled => _enabled;

  set enabled(bool value) {
    _enabled = value;

    notifyListeners();
  }

  void addInvite( int userId ) {
    invites.add(userId);
  }

  void removeInvite( int userId ) {
    invites.remove(userId);
  }

  Future<ApiResponse<EventResponse>> createConfirmedEvent() async {
    setStatus(ViewModelStatus.busy);
    try {
      final confirmedEvent = ConfirmedEvent(
        activity: description,
        invitedList: invites.toList(growable: false),
      );
      final data = await _webApi.createConfirmedEvent(confirmedEvent);
      setStatus(ViewModelStatus.idle);
      return ApiResponse.completed('Event Cancelled', data[0]);
    } on FetchDataException catch (e) {
      print(e);
      setStatus(ViewModelStatus.error);
      return ApiResponse.error(e.toString());
    }
  }

  Future<DataListPage<InviteFriendPageItem>> loadNext( String? pageKey ) async {
    final data = await _webApi.getFriendPage(pageKey);
    return data[0];
  }
}
