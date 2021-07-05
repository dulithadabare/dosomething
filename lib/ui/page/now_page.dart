import 'package:dosomething/business_logic/model/happening_feed_item.dart';
import 'package:dosomething/business_logic/view_model/current_activity_view_model.dart';
import 'package:dosomething/business_logic/view_model/happening_feed_view_model.dart';
import 'package:dosomething/business_logic/view_model/user_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/page/add_now_page.dart';
import 'package:dosomething/ui/page/now_details_page.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/infinite_list.dart';
import 'package:dosomething/ui/widget/join_button.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:image_stack/image_stack.dart';

class NowPage extends StatelessWidget {

  void _pushCreate(BuildContext context) async {

    final eventId = await Navigator.of(context).push(
      MaterialPageRoute<int>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return AddNowPage();
        }, // ...to here.
      ),
    );

    if(eventId != null && eventId != -1 ) {
      final currentActivityModel = Provider.of<CurrentActivityViewModel>(context, listen: false);
      currentActivityModel.load();
      _pushNowDetailsPage(context, eventId);
    }
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
                    Text('Now', style: Styles.headerBlack36,),
                    IconButton(icon: Icon( Icons.add), onPressed: () => _pushCreate(context))
                  ],
                ),
              ),
              Expanded(
                child: MultiProvider(
                  providers: [
                    // ChangeNotifierProvider<CurrentActivityViewModel>.value( value: _currentActivityViewModel,),
                    ChangeNotifierProvider<HappeningFeedViewModel>(create: (_) => HappeningFeedViewModel(),),
                  ],
                  child: InfiniteNowList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfiniteNowList extends StatelessWidget {
  const InfiniteNowList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteList<HappeningFeedViewModel, HappeningPageItem>(
      itemBuilder: (context, pageItem, index) => NowListItem(pageItem: pageItem),
      noItemsFoundMessage: 'No Events',
    );
  }
}

class NowListItem extends StatelessWidget {
  final HappeningPageItem pageItem;

  NowListItem({Key? key, required this.pageItem}) : super(key: key);

  void _pushPopDetailsPage(BuildContext context, HappeningPageItem pageItem, int eventId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return NowDetailsPage( eventId: eventId, pageItem: pageItem,);
        }, // ...to here.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = pageItem.event;
    final createdDt = DateTime.fromMillisecondsSinceEpoch(pageItem.timestampUtc);
    final createdTimeAgo = timeago.format(createdDt);

    String title = '${event.activity.characters.first.toLowerCase()}${event.activity.substring(1)}';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ActiveEvent(pageItem: pageItem,),
          InkWell(
            onTap: () => _pushPopDetailsPage(context, pageItem, event.id!),
            child: SizedBox(
              height: 200,
              child: Container(
                padding: EdgeInsets.fromLTRB( 20.0 , 20.0, 20.0, 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Styles.headerBlack36,),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(createdTimeAgo, style: Styles.headerGrey18,),
                        ActiveList(pageItem: pageItem,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ActiveEvent extends StatelessWidget {
  final HappeningPageItem pageItem;

  ActiveEvent({Key? key, required this.pageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<UserViewModel>(context);
    return  Consumer<CurrentActivityViewModel>(
      builder: (context, model, child) {
        String bannerTitle = '';

        final activeEvent = model.activeEvent;
        if( activeEvent != null && activeEvent.eventId == pageItem.event.id ) {
          bannerTitle = 'You are here';
        }

        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(bannerTitle, style: Styles.headerBlack18),
              JoinButton(eventId: pageItem.event.id!),
            ],
          ),
        );
      },
    );
  }
}

class ActiveList extends StatelessWidget {
  final HappeningPageItem pageItem;

  ActiveList({Key? key, required this.pageItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String count = '';
    if(pageItem.activeCount > pageItem.activeFriendList.length) {
      count = '+${pageItem.activeCount - pageItem.activeFriendList.length} others';
    }

    final children = pageItem.activeFriendList.map((e) => Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.yellow,
            Colors.white,
          ],
        ),
      ),
    )).toList();

    return Row(
      children: [
        ImageStack.widgets(
          children: children,
          totalCount: pageItem.activeFriendList.length,
          widgetCount: 3,
          widgetBorderColor: Colors.black,
        ),
        Text(count, style: Styles.headerBlack18,)
      ],
    );
  }
}



