import 'package:dosomething/business_logic/view_model/app_notification_view_model.dart';
import 'package:dosomething/business_logic/view_model/current_activity_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';

import 'notifications_page.dart';
import 'now_page.dart';
import 'pops_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppNotificationViewModel _notificationModel;

  @override
  void initState() {
    super.initState();
    final _activityModel = Provider.of<CurrentActivityViewModel>(context, listen: false);
    _notificationModel = Provider.of<AppNotificationViewModel>(context, listen: false);
    _notificationModel.initializeMessaging();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _activityModel.load());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor.withOpacity(1.0),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.star),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
          ),
          BottomNavigationBarItem(
            icon: Consumer<AppNotificationViewModel>(
              builder: (context, model, child) {
                if(model.newNotificationAvailable) {
                  return Badge(
                    shape: BadgeShape.circle,
                    borderRadius: BorderRadius.circular(100),
                    child: Icon(CupertinoIcons.bell),
                    badgeContent: Container(
                      height: 5,
                      width: 5,
                      // decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    ),
                    position: BadgePosition.topEnd(top: 0, end: 0),
                  );
                } else {
                  return Icon(CupertinoIcons.bell);
                }
              },
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        late CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: PopsPage(),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: NowPage(),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              WidgetsBinding.instance!
                  .addPostFrameCallback((_) => _notificationModel.save(false));
              return CupertinoPageScaffold(
                child: NotificationsPage(),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: SettingsPage(),
              );
            });
            break;
        }
        return returnValue;
      },
    );
  }
}

