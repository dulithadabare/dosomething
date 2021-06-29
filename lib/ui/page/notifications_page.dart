import 'package:dosomething/business_logic/model/notification_page_item.dart';
import 'package:dosomething/business_logic/view_model/notifications_view_model.dart';
import 'package:dosomething/constants.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/page/now_details_page.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'pop_details_page.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications', style: Styles.headerBlack36,),
                  ],
                ),
              ),
              Expanded(
                child: ChangeNotifierProvider<NotificationViewModel>(
                  create: (_) => NotificationViewModel(),
                  child: NotificationsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  late final NotificationViewModel _model;

  final _pagingController = PagingController<String?, NotificationPageItem>(
    firstPageKey: null,
  );

  @override
  void initState() {
    _model = Provider.of<NotificationViewModel>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String? pageKey) async {
    print('Fetching page $pageKey');
    try {
      final newPage = await _model.loadNext(pageKey);

      print('Page nexyPageKey ${newPage.nextPageKey}');
      final isLastPage = newPage.nextPageKey == null;
      final newItems = newPage.itemList;

      if (isLastPage) {
        // 3
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newPage.nextPageKey;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      // 4
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
      ),
      child: PagedListView.separated(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        builderDelegate: PagedChildBuilderDelegate<NotificationPageItem>(
          itemBuilder: (context, pageItem, index) => NotificationListItem(
            pageItem: pageItem,
          ),
          firstPageErrorIndicatorBuilder: (context) => ErrorMessage(
            message:_pagingController.error.toString(),
          ),
          noItemsFoundIndicatorBuilder: (context) => Column(
            children: [
              Center(
                child: Text('No notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationListItem extends StatelessWidget {
  final NotificationPageItem pageItem;

  NotificationListItem({Key? key, required this.pageItem}) : super(key: key);

  void _pushPopDetailsPage(BuildContext context, int eventId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return PopDetailsPage( eventId: eventId,);
        }, // ...to here.
      ),
    );
  }

  void _pushNowDetailsPage(BuildContext context, int eventId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return NowDetailsPage( eventId: eventId,);
        }, // ...to here.
      ),
    );
  }

  void _pushPage(BuildContext context, NotificationPageItem pageItem) {
    if( pageItem.type == Constants.APP_NOTIFICATION_EVENT_INTEREST || pageItem.type == Constants.APP_NOTIFICATION_EVENT_PEEK ) {
      _pushPopDetailsPage(context, pageItem.decodedPayload.eventId);
    } else if( pageItem.type != Constants.APP_NOTIFICATION_NONE ) {
      _pushNowDetailsPage(context, pageItem.decodedPayload.eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdDt = DateTime.fromMillisecondsSinceEpoch(pageItem.timestampUtc);
    final createdTimeAgo = timeago.format(createdDt);

    String title = '${pageItem.message}';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => _pushPage(context, pageItem),
        child: SizedBox(
          height: 120,
          child: Container(
            padding: EdgeInsets.fromLTRB( 20.0 , 20.0, 20.0, 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Styles.headerBlack18,),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(createdTimeAgo, style: Styles.headerGrey18,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


