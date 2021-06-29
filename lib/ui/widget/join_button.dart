import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/current_activity_view_model.dart';
import 'package:dosomething/business_logic/view_model/user_view_model.dart';
import 'package:dosomething/ui/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinButton extends StatefulWidget {
  final int eventId;

  const JoinButton({Key? key,required this.eventId}) : super(key: key);

  @override
  _JoinButtonState createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  bool _loading = false;

  void _join(CurrentActivityViewModel model, int eventId, int userId) async {
    setState(() {
      _loading = true;
    });
    await model.joinEvent(eventId, userId);
    setState(() {
      _loading = false;
    });
  }

  void _leave(CurrentActivityViewModel model, int eventId, int userId) async {
    setState(() {
      _loading = true;
    });
    await model.leaveEvent(eventId, userId);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<UserViewModel>(context, listen: false);
    final model = Provider.of<CurrentActivityViewModel>(context);

    String buttonLabel = 'Join';
    VoidCallback onPressed =  () => _join(model, widget.eventId, appModel.user!.userId!);

    final activeEvent = model.activeEvent;
    if( activeEvent != null && activeEvent.eventId == widget.eventId ) {
      buttonLabel = 'Leave';
      onPressed = () => _leave(model, widget.eventId, appModel.user!.userId!);
    }

    return RoundedButton( buttonLabel: buttonLabel, onPressed: onPressed, loading: _loading, );
  }
}
