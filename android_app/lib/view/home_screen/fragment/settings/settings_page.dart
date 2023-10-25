import 'package:led_alarm/service/authentication_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/home_screen/fragment/settings/widget/choose_color_dialog.dart';
import 'package:led_alarm/view/home_screen/fragment/settings/widget/clear_data_dialog.dart';
import 'package:led_alarm/view/home_screen/fragment/settings/widget/set_pre_alarm_time_dialog.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final AuthenticationService _authenticationService = locator.get<AuthenticationService>();
  bool loading = true;
  late final String? photoUrl;
  late final String? name;
  late final String? email;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) async {
      photoUrl = prefs.getString('photo_url');
      name = prefs.getString('name');
      email = prefs.getString('email');
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        _buildLabelSection(),
        _buildHeaderSection(context),
        _buildGeneralSection(),
        _buildAccountSection(),
        _buildDeviceSection(),
        _buildFooterSection(),
      ],
    );
  }

  CustomSection _buildLabelSection() {
    return CustomSection(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(left: 25, top: 25),
          child: Text(
            AppLocalizations.of(context)!.settings,
            style: MyTextStyle.TitleTextStyle, // TextStyle(, fontSize: 22, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  CustomSection _buildHeaderSection(BuildContext context) {
    return CustomSection(
      child: Container(
        child: Padding(
            padding: EdgeInsets.only(left: 25, top: 25, bottom: 5),
            child: !loading ? Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  photoUrl != null
                      ? ClipOval(
                    child: Material(
                      color: Colors.black26.withOpacity(0.3),
                      child: Image.network(
                        photoUrl!,
                        fit: BoxFit.fitHeight,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  )
                      : ClipOval(
                    child: Material(
                      color: Colors.black26.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.black26,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? 'mock',
                        style: MyTextStyle.Body1TextStyle, // TextStyle(fontSize: 18),
                      ),
                      Text(
                        email ?? 'mock',
                        style: MyTextStyle
                            .Subtitle1TextStyle, //TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ],
              ),
            )
                :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Roman Tester',
                  style: MyTextStyle.Body1TextStyle, // TextStyle(fontSize: 18),
                ),
                Text(
                  "Edit personal details",
                  style: MyTextStyle
                      .Subtitle1TextStyle, //TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                )
              ],
            ),
        ),
      ),
    );
  }

  SettingsSection _buildGeneralSection() {
    const String mode = String.fromEnvironment('mode');

    List<SettingsTile> tiles = [];

    if (mode == "mock") {
      tiles.add(SettingsTile(
        title: "Sandbox",
        // subtitle: state.name,
        leading: Padding(padding: EdgeInsets.only(left: 7), child: Icon(Icons.extension)),
        onPressed: (BuildContext context) async {
          Navigator.pushNamed(context, '/sandbox');
        },
      ));
    }

    return SettingsSection(
      titlePadding: EdgeInsets.only(
        left: 25,
        top: 20,
        bottom: 5,
      ),
      title: AppLocalizations.of(context)!.general,
      tiles: tiles
        ..addAll([
          SettingsTile(
            key: const Key("clearDataButton"),
            title: AppLocalizations.of(context)!.clearData,
            // subtitle: AppLocalizations.of(context)!.clearsSavedDamages,
            leading: _prepareSectionIcon(Icon(Icons.cleaning_services_rounded)),
            onPressed: (BuildContext context) async {
              showDialog<String>(context: context, builder: (BuildContext context) => ClearDataDialog());
            },
          ),
          // SettingsTile.switchTile(
          //   title: AppLocalizations.of(context)!.notification,
          //   leading: _prepareSectionIcon(Icon(Icons.notifications_active_outlined)),
          //   switchValue: false,
          //   onToggle: (bool value) {
          //     setState(() {});
          //   },
          // ),
          SettingsTile(
            title: AppLocalizations.of(context)!.changeTheme,
            // subtitle: state.name,
            leading: Padding(padding: EdgeInsets.only(left: 7), child: Icon(Icons.widgets_outlined)),
            onPressed: (BuildContext context) async {
              showDialog<String>(context: context, builder: (BuildContext context) => ChooseColorDialog());
            },
          ),
        ]),
    );
  }

  SettingsSection _buildAccountSection() {
    return SettingsSection(
      titlePadding: EdgeInsets.only(
        left: 25,
        top: 20,
        bottom: 5,
      ),
      title: AppLocalizations.of(context)!.account,
      tiles: [
        SettingsTile(
          key: const Key("signOutButton"),
          title: AppLocalizations.of(context)!.signOut,
          leading: Padding(
            padding: EdgeInsets.only(left: 7),
            child: Icon(
              Icons.logout_outlined,
            ),
          ),
          onPressed: (BuildContext context){
            _authenticationService.signOutGoogle(context);
          },
        ),
      ],
    );
  }

  SettingsSection _buildDeviceSection() {
    return SettingsSection(
      titlePadding: EdgeInsets.only(
        left: 25,
        top: 20,
        bottom: 5,
      ),
      title: "Device",
      tiles: [
        // SettingsTile(
        //   key: const Key("changeIPButton"),
        //   title: AppLocalizations.of(context)!.unpair,
        //   // subtitle: AppLocalizations.of(context)!.changeIP,
        //   //     .clearsSavedDamagesAndLogsOut,
        //   leading: _prepareSectionIcon(Icon(Icons.leak_add_outlined)),
        //   onPressed: (BuildContext context) async {},
        // ),
        SettingsTile(
          key: const Key("preAlarmButton"),
          title: AppLocalizations.of(context)!.preAlarmTime,
          // subtitle: AppLocalizations.of(context)!
          //     .clearsSavedDamagesAndLogsOut,
          leading: _prepareSectionIcon(Icon(Icons.lightbulb_outline_rounded)),
          onPressed: (BuildContext context) async {
            showDialog<String>(context: context, builder: (BuildContext context) => SetPreAlarmTime());
          },
        ),
      ],
    );
  }

  CustomSection _buildFooterSection() {
    return CustomSection(
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "App ver 0.0.1",
              style: MyTextStyle.Body2TextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _prepareSectionIcon(Widget icon) {
    return Padding(padding: EdgeInsets.only(left: 7), child: icon);
  }
}
