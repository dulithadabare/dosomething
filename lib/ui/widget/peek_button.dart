import 'package:dosomething/business_logic/model/interested_friend_page_item.dart';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/view_model/interested_friend_view_model.dart';
import 'package:dosomething/ui/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeekButton extends StatefulWidget {
  final InterestedFriendPageItem pageItem;
  final int eventId;

  PeekButton({Key? key, required this.pageItem, required this.eventId}) : super(key: key);

  @override
  _PeekButtonState createState() => _PeekButtonState();
}

class _PeekButtonState extends State<PeekButton> {
  bool _loading = false;

  void _peek(int eventId, int userId, InterestedFriendViewModel model) async {
    setState(() {
      _loading = true;
    });

    final response = await model.peek(eventId, userId);

    if(response.status == ApiResponseStatus.COMPLETED) {
      widget.pageItem.peekBack = false;
      widget.pageItem.peekSent = true;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _model = Provider.of<InterestedFriendViewModel>(context);
    final pageItem = widget.pageItem;

    if(pageItem.peekBack) {
      return RoundedButton(
          buttonLabel: 'Peek Back',
          onPressed: () => _peek(widget.eventId, pageItem.user.userId, _model),
          loading: _loading
      );
    } else if (pageItem.peekSent) {
      return RoundedButton(
          buttonLabel: 'Peek Sent',
          onPressed: null,
          loading: false
      );
    } else {
      return RoundedButton(
          buttonLabel: 'Peek',
          onPressed: () => _peek(widget.eventId, pageItem.user.userId, _model),
          loading: _loading
      );
    }
  }
}