import 'package:dosomething/business_logic/model/upcoming_page_item.dart';
import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/event_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/interested_friend_list.dart';
import 'package:dosomething/ui/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopDetailsPage extends StatelessWidget {
  final int eventId;
  final UpcomingPageItem? pageItem;

  PopDetailsPage({Key? key, required this.eventId, this.pageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventViewModel>(
      create: (_) => pageItem != null ? EventViewModel.fromPageItem(pageItem!) : EventViewModel.fromEventId(eventId),
      child: Consumer<EventViewModel>(
          builder: (context, model, child) {
            return Scaffold(
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
                    PopDetails( eventId: eventId,),
                    InterestedFriendListTab( eventId: eventId,),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}

class PopDetails extends StatelessWidget {
  final int eventId;

  PopDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EventViewModel>(context);
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
                InterestButton(),
              ],
            ),
          ],
        ),
      );
    }
  }
}

class InterestButton extends StatelessWidget {

  void _addInterest(EventViewModel model, int eventId){
    model.addEventInterest(eventId);
  }

  void _removeInterest(EventViewModel model, int eventId){
    model.removeEventInterest(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<EventViewModel>(context);
    final eventResponse = model.eventResponse;
    final event = eventResponse!.event;

    String buttonLabel = 'I am interested';
    VoidCallback? onPressed =  () => _addInterest(model, event.id!);

    if( eventResponse.interested! ) {
      buttonLabel = 'Remove Interest';
      onPressed = () => _removeInterest(model, event.id!);
    }

    return RoundedButton( buttonLabel: buttonLabel, onPressed: onPressed, loading: false, );
  }
}



