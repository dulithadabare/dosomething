import 'package:dosomething/business_logic/model/active_user.dart';
import 'package:dosomething/business_logic/view_model/active_user_list_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'infinite_list.dart';

class ActiveFriendListTab extends StatelessWidget {
  final int eventId;

  ActiveFriendListTab({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Active', style: Styles.headerBlack36,),
        ),
        Expanded(
          child: ChangeNotifierProvider<ActiveUserListViewModel>(
              create: (_) => ActiveUserListViewModel(eventId),
              child: InfiniteActiveList(),
          ),
        ),
      ],
    );
  }
}

class InfiniteActiveList extends StatelessWidget {
  const InfiniteActiveList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteList<ActiveUserListViewModel, ActivePageItem>(
      itemBuilder: (context, pageItem, index) => ActiveListItem(pageItem: pageItem),
      noItemsFoundMessage: 'No active users',
      separatorHeight: 30.0,
    );
  }
}

class ActiveListItem extends StatelessWidget {
  final ActivePageItem pageItem;

  ActiveListItem({Key? key, required this.pageItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = pageItem.user;
    final createdDt = DateTime.fromMillisecondsSinceEpoch(pageItem.timestampUtc);
    final createdTimeAgo = timeago.format(createdDt);

    return Container(
      height: 70,
      child: Row(
        children: [
          Container(
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.displayName!, style: Styles.headerBlack18,),
                Spacer(),
                Text(createdTimeAgo, style: Styles.headerGrey18,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


