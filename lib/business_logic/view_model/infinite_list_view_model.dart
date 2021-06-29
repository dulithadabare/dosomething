import 'package:dosomething/business_logic/model/data_list_page.dart';
import 'package:flutter/foundation.dart';

abstract class InfiniteListViewModel<T> extends ChangeNotifier{
  Future<DataListPage<T>> loadNext( String? pageKey );
}