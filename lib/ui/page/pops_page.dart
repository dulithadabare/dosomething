import 'package:dosomething/business_logic/model/upcoming_page_item.dart';
import 'package:dosomething/business_logic/view_model/upcoming_feed_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/page/pop_details_page.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/infinite_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/services.dart';

import 'add_pop_page.dart';

class PopsPage extends StatelessWidget {

  void _pushCreateEvent(BuildContext context) async{
    getIdToken();
    final eventId = await Navigator.of(context).push(
      MaterialPageRoute<int>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return AddPopPage();
        }, // ...to here.
      ),
    );

    if(eventId != null && eventId != -1 ) {
      _pushPopDetailsPage(context, eventId);
    }
  }

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

  void getIdToken() async {
    final token = await FirebaseAuth.instance.currentUser!.getIdToken();
    print('Copied');
    Clipboard.setData(ClipboardData(text: token));
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
                      SelectableText('Pops', style: Styles.headerBlack36,),
                      IconButton(icon: Icon( Icons.add), onPressed: () => _pushCreateEvent(context))
                    ],
                  ),
                ),
                Expanded(
                  child: ChangeNotifierProvider<UpcomingFeedViewModel>(
                    create: (_) => UpcomingFeedViewModel(),
                    child: InfinitePopList(),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

class InfinitePopList extends StatelessWidget {
  const InfinitePopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteList<UpcomingFeedViewModel, UpcomingPageItem>(
      itemBuilder: (context, pageItem, index) => PopListItem(pageItem: pageItem),
      noItemsFoundMessage: 'No Pops',
    );
  }
}

class PopListItem extends StatelessWidget {
  final UpcomingPageItem pageItem;

  PopListItem({Key? key, required this.pageItem}) : super(key: key);

  void _pushPopDetailsPage(BuildContext context, UpcomingPageItem pageItem, int eventId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return PopDetailsPage( eventId: eventId, pageItem: pageItem,);
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
      child: InkWell(
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


