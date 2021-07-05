import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/create_event_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/loading_large.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddPopPage extends StatelessWidget {
  
  void _createEvent( BuildContext context, CreateEventViewModel model ) async {
    final response = await model.createEvent();

    if( response.status == ApiResponseStatus.COMPLETED ) {
      print('Post Created');
      final snackBar = SnackBar(content: Text('Sent Pop!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop(response.data!.event.id);
    } else  if( response.status == ApiResponseStatus.ERROR ) {
      final snackBar = SnackBar(content: Text('Sending Pop Failed!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateEventViewModel>(
      create: (_) => CreateEventViewModel(),
      child: Consumer<CreateEventViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                leading: CloseButton(
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(-1),
                ),
                title: Text('Add Pop', style: TextStyle(
                    color: Colors.black
                ),),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  TextButton(
                      onPressed: model.enabled ? () => _createEvent(context, model) : null,
                      child: Text('Send',
                        style: model.enabled ? TextStyle(color: Colors.black,) : TextStyle(color: Colors.grey,),
                      )
                  ),
                ],
              ),
              body: AddPop(),
            );
          }
      ),
    );
  }
}


class AddPop extends StatefulWidget {
  @override
  _AddPopState createState() => _AddPopState();
}

class _AddPopState extends State<AddPop> {
  TextEditingController _nounController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final model = Provider.of<CreateEventViewModel>(context, listen: false);
    _nounController.addListener(() => setEvent(model));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _nounController.dispose();
    super.dispose();
  }

  void setEvent( CreateEventViewModel model ) {
    bool valid = true;
    final value = _nounController.text;
    model.description = value;

    if( value.characters.isEmpty ) {
      valid = false;
    }

    if( !valid ) {
      model.enabled = false;
    } else {
      model.enabled = true;
    }
    // print(model.description);
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CreateEventViewModel>(context);

    if(model.status == ViewModelStatus.busy) {
      return Center(
        child: LoadingLarge(),
      );
    } else if(model.status == ViewModelStatus.error) {
      return ErrorMessage(message: 'Could not send Pop');
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _nounController,
              maxLines: null,
              autofocus: true,
              expands: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(140),
                FilteringTextInputFormatter.singleLineFormatter,
              ],
              style: Styles.headerBlack76,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'dinner today at 7pm in the Park',
                hintStyle: Styles.headerGrey,
              ),
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }
}

