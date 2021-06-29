import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:dosomething/business_logic/model/event_response.dart';
import 'package:dosomething/business_logic/model/interested_friend_page_item.dart';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/view_model/infinite_list_view_model.dart';
import 'package:dosomething/service/api_helper.dart';
import 'package:dosomething/service/web_api_implementation.dart';

class InterestedFriendViewModel extends InfiniteListViewModel {
  final WebApi _webApi = WebApi();
  final int eventId;

  InterestedFriendViewModel(this.eventId);

  Future<ApiResponse<EventResponse>> peek( int eventId, int friendId ) async {
    try {
      final data = await _webApi.peek(eventId, friendId);
      return ApiResponse.completed('completed', data[0]);
    } on FetchDataException catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  @override
  Future<DataListPage<InterestedFriendPageItem>> loadNext( String? pageKey ) async {
    final data = await _webApi.getInterestedFriendFeedPage(eventId, pageKey);

    return data[0];
  }

}
