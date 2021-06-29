import 'package:dosomething/business_logic/view_model/abstract_view_model.dart';
import 'package:dosomething/business_logic/view_model/profile_view_model.dart';
import 'package:dosomething/business_logic/view_model/user_view_model.dart';
import 'package:dosomething/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<UserViewModel>(context, listen: false);
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
                    Text('Settings', style: Styles.headerBlack36,),
                  ],
                ),
              ),
              Expanded(
                child: ChangeNotifierProvider<ProfileViewModel>(
                  create: (_) => ProfileViewModel(appModel.user!.firebaseUid!),
                  child: SettingsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SettingHeader(title: 'Profile',),
        Profile(),
        SettingHeader(title: 'Preferences',),
        Preferences(),
      ],
    );
  }
}

class SettingHeader extends StatelessWidget {
  final String title;

  SettingHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Styles.headerGrey36,),
    );
  }
}


class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProfileViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ProfileRow(header: 'Name', value: model.status == ViewModelStatus.busy ? 'Loading' : model.userProfile!.displayName!),
          ProfileRow(header: 'Friends', value: model.status == ViewModelStatus.busy ? 'Loading' : model.friendCount.toString()),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String header;
  final String? value;
  final GestureTapCallback? onTap;

  ProfileRow({Key? key, required this.header, this.value, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header, style: Styles.headerBlack18,),
            value != null ? Text(value!, style: Styles.bodyGrey18,) : Container(),
          ],
        ),
      ),
    );
  }
}

class Preferences extends StatelessWidget {

  void _logout(BuildContext context) {
    final appModel = Provider.of<UserViewModel>(context, listen: false);
    appModel.logout();

    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     '/sign-in', (Route<dynamic> route) => false
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileRow(header: 'Log out', onTap: () => _logout(context),),
        ],
      ),
    );
  }
}




