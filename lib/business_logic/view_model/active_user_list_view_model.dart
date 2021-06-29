import 'package:dosomething/business_logic/model/active_user.dart';
import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:dosomething/business_logic/view_model/infinite_list_view_model.dart';
import 'package:dosomething/service/web_api_implementation.dart';

class ActiveUserListViewModel extends InfiniteListViewModel<ActivePageItem> {
  final WebApi _webApi = WebApi();

  final int eventId;

  ActiveUserListViewModel(this.eventId);

  @override
  Future<DataListPage<ActivePageItem>> loadNext( String? pageKey ) async {
    final data = await _webApi.getActivePage(eventId,pageKey);

    return data[0];
  }
}
