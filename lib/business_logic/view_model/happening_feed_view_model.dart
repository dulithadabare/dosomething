import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:dosomething/business_logic/model/happening_feed_item.dart';
import 'package:dosomething/business_logic/view_model/infinite_list_view_model.dart';
import 'package:dosomething/service/web_api_implementation.dart';

class HappeningFeedViewModel extends InfiniteListViewModel<HappeningPageItem> {
  final WebApi _webApi = WebApi();

  @override
  Future<DataListPage<HappeningPageItem>> loadNext( String? pageKey ) async {
    final data = await _webApi.getHappeningFeedPage(pageKey);

    return data[0];
  }
}
