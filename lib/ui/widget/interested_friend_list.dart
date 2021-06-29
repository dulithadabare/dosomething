import 'package:dosomething/business_logic/model/interested_friend_page_item.dart';
import 'package:dosomething/business_logic/view_model/interested_friend_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'error_message.dart';
import 'peek_button.dart';

class InterestedFriendListTab extends StatelessWidget {
  final int eventId;

  InterestedFriendListTab({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InterestedFriendViewModel>(
        create: (_) => InterestedFriendViewModel(eventId),
        child: Consumer<InterestedFriendViewModel>(builder: (context, model, child) {
          return InterestedFriendList();
        }));
  }
}

class InterestedFriendList extends StatefulWidget {
  @override
  _InterestedFriendListState createState() => _InterestedFriendListState();
}

class _InterestedFriendListState extends State<InterestedFriendList> {
  late final InterestedFriendViewModel _model;
  final _pagingController = PagingController<String?, InterestedFriendPageItem>(
    firstPageKey: null,
  );

  @override
  void initState() {
    _model = Provider.of<InterestedFriendViewModel>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

      final isLastPage = newPage.nextPageKey == null;
      final newItems = newPage.itemList;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = newPage.nextPageKey;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      print(s);
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<InterestedFriendViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Interested', style: Styles.headerBlack36,),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
            ),
            child: PagedListView.separated(
              pagingController: _pagingController,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(
                height: 30,
              ),
              builderDelegate: PagedChildBuilderDelegate<InterestedFriendPageItem>(
                itemBuilder: (context, item, index) => InterestedFriendListItem(pageItem: item, eventId: model.eventId,),
                firstPageErrorIndicatorBuilder: (context) => ErrorMessage(
                  message:_pagingController.error.toString(),
                ),
                noItemsFoundIndicatorBuilder: (context) => Column(
                  children: [
                    Center(
                      child: Text('No events'),
                    ),
                  ],
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }
}

class InterestedFriendListItem extends StatelessWidget {
  final InterestedFriendPageItem pageItem;
  final int eventId;

  InterestedFriendListItem({Key? key, required this.pageItem, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = pageItem.user;
    final anonymous = user.displayName == null;

    if( anonymous ) {
      return HiddenFriendListItem(pageItem: pageItem, eventId: eventId);
    } else if (pageItem.peekBack) {
      return PartialHiddenFriendListItem(pageItem: pageItem, eventId: eventId);
    } else {
      return FriendListItem(pageItem: pageItem, eventId: eventId);
    }
  }
}

class HiddenFriendListItem extends StatelessWidget {
  final InterestedFriendPageItem pageItem;
  final int eventId;

  HiddenFriendListItem({Key? key, required this.pageItem, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdDt = DateTime.fromMillisecondsSinceEpoch(pageItem.timestampUtc);
    final createdTimeAgo = timeago.format(createdDt);

    return InterestedListTile(
      leading: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.yellow,
              Colors.white,
            ],
          ),
        ),
      ),
      title: PeekButton(pageItem: pageItem, eventId: eventId),
      subtitle: Text(createdTimeAgo, style: Styles.headerGrey18,),
    );
  }
}

class PartialHiddenFriendListItem extends StatelessWidget {
  final InterestedFriendPageItem pageItem;
  final int eventId;

  PartialHiddenFriendListItem({Key? key, required this.pageItem, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = pageItem.user;

    return InterestedListTile(
        leading: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.yellow,
                Colors.white,
              ],
            ),
          ),
        ),
        title: PeekButton(pageItem: pageItem, eventId: eventId),
        subtitle: Text(user.displayName!, style: Styles.headerGrey18,),
    );
  }
}

class FriendListItem extends StatelessWidget {
  final InterestedFriendPageItem pageItem;
  final int eventId;

  FriendListItem({Key? key, required this.pageItem, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = pageItem.user;
    final createdDt = DateTime.fromMillisecondsSinceEpoch(pageItem.timestampUtc);
    final createdTimeAgo = timeago.format(createdDt);

    return InterestedListTile(
        leading: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.white,
              ],
            ),
          ),
        ),
        title: Text(user.displayName!, style: Styles.headerBlack18 ),
        subtitle: Text(createdTimeAgo, style: Styles.headerGrey18,)
    );
  }
}

class InterestedListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;

  InterestedListTile({Key? key, required this.leading, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        children: [
          leading,
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                Spacer(),
                subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }
}


