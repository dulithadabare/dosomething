import 'package:dosomething/business_logic/model/invite_friend_page_item.dart';
import 'package:dosomething/business_logic/model/response.dart';
import 'package:dosomething/business_logic/view_model/create_confirmed_event_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:dosomething/ui/widget/error_message.dart';
import 'package:dosomething/ui/widget/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class AddNowPage extends StatefulWidget {
  @override
  _AddNowPageState createState() => _AddNowPageState();
}

class _AddNowPageState extends State<AddNowPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _next(CreateConfirmedEventViewModel model) {
    _tabController.animateTo(1);
    model.enabled = true;
  }

  void _createConfirmedEvent( BuildContext context, CreateConfirmedEventViewModel model ) async {
    final response = await model.createConfirmedEvent();

    if( response.status == ApiResponseStatus.COMPLETED ) {
      print('Event Created');
      final snackBar = SnackBar(content: Text('Sent Event!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop(response.data?.event?.id);
    } else  if( response.status == ApiResponseStatus.ERROR ) {
      final snackBar = SnackBar(content: Text('Sending Event Failed!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateConfirmedEventViewModel>(
      create: (_) => CreateConfirmedEventViewModel(),
      child: Consumer<CreateConfirmedEventViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                leading: CloseButton(
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('Add Event', style: TextStyle(
                    color: Colors.black
                ),),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  _tabController.index == 0 ? TextButton(
                      onPressed: model.enabled ? () => _next(model) : null,
                      child: Text('Next',
                        style: model.enabled ? TextStyle(color: Colors.black,) : TextStyle(color: Colors.grey,),
                      )
                  ) : TextButton(
                      onPressed: model.enabled ? () => _createConfirmedEvent(context, model) : null,
                      child: Text('Done',
                        style: model.enabled ? TextStyle(color: Colors.black,) : TextStyle(color: Colors.grey,),
                      )
                  ),
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  AddEventTab(),
                  InviteFriendTab(),
                ],
              ),
            );
          }
      ),
    );
  }
}



class AddEventTab extends StatefulWidget {
  @override
  _AddEventTabState createState() => _AddEventTabState();
}

class _AddEventTabState extends State<AddEventTab> {
  TextEditingController _nounController = TextEditingController();

  @override
  void initState() {
    final model = Provider.of<CreateConfirmedEventViewModel>(context, listen: false);
    _nounController.addListener(() => setEvent(model));
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _nounController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void setEvent( CreateConfirmedEventViewModel model ) {
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
  }

  @override
  Widget build(BuildContext context) {
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
              enableInteractiveSelection: true,
            ),
          ),
        ],
      ),
    );
  }
}

class InviteFriendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InviteFriendList();
  }
}

class InviteFriendList extends StatefulWidget {
  @override
  _InviteFriendListState createState() => _InviteFriendListState();
}

class _InviteFriendListState extends State<InviteFriendList> {
  late final CreateConfirmedEventViewModel _model;
  final _pagingController = PagingController<String?, InviteFriendPageItem>(
    firstPageKey: null,
  );

  @override
  void initState() {
    _model = Provider.of<CreateConfirmedEventViewModel>(context, listen: false);
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
        builderDelegate: PagedChildBuilderDelegate<InviteFriendPageItem>(
          itemBuilder: (context, item, index) => InviteFriendListItem(pageItem: item),
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
    );
  }
}

class InviteFriendListItem extends StatelessWidget {
  final InviteFriendPageItem pageItem;

  InviteFriendListItem({Key? key, required this.pageItem }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = pageItem.user;

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
                InviteButton(pageItem: pageItem),
                Spacer(),
                Text(user.displayName!, style: Styles.headerGrey18,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InviteButton extends StatefulWidget {
  final InviteFriendPageItem pageItem;

  InviteButton({Key? key, required this.pageItem}) : super(key: key);

  @override
  _InviteButtonState createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton> {
  late final InviteFriendPageItem _pageItem;

  @override
  void initState() {
    super.initState();
    _pageItem = widget.pageItem;
  }

  void _invite(CreateConfirmedEventViewModel model, int userId) {
    model.addInvite(userId);

    setState(() {
      _pageItem.invited = true;
    });
  }

  void _remove(CreateConfirmedEventViewModel model, int userId) {
    model.removeInvite(userId);

    setState(() {
      _pageItem.invited = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _model = Provider.of<CreateConfirmedEventViewModel>(context);

    if(_pageItem.invited) {
      return RoundedButton(
          buttonLabel: 'Remove',
          onPressed: () => _remove(_model, _pageItem.user.userId),
          loading: false
      );
    } else {
      return RoundedButton(
          buttonLabel: 'Invite',
          onPressed: () => _invite(_model, _pageItem.user.userId),
          loading: false
      );
    }
  }
}


