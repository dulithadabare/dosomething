import 'package:dosomething/business_logic/model/happening_feed_item.dart';
import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/confirmed_event_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/widget/active_friend_list.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/join_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class NowDetailsPage extends StatelessWidget {
  final int eventId;
  final HappeningPageItem? pageItem;

  NowDetailsPage({Key? key, required this.eventId, this.pageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConfirmedEventViewModel>(
          create: (_) => pageItem != null
              ? ConfirmedEventViewModel.fromPageItem(pageItem!)
              : ConfirmedEventViewModel.fromEventId(eventId),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            // IconButton(icon: Icon(Icons.favorite, color: Colors.black,), onPressed: () => _tabController.animateTo(1))
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: TabBarView(
            children: [
              NowDetails(
                eventId: eventId,
              ),
              ActiveFriendListTab(
                eventId: eventId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NowDetails extends StatelessWidget {
  final int eventId;

  NowDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ConfirmedEventViewModel>(context);
    if ( model.status == ViewModelStatus.busy ) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if ( model.status == ViewModelStatus.error ) {
      return ErrorMessage(message: 'Error Occurred');
    } else {
      final _eventResponse = model.eventResponse;
      final event = _eventResponse!.event;

      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${event.activity}',
              style: Styles.headerBlack76,
            ),
            Spacer(
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JoinButton(eventId: event.id!,),
              ],
            ),
          ],
        ),
      );
    }
  }
}

