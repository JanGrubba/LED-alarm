import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/view/home_screen/fragment/alarms_list/alarms_list_page.dart';
import 'package:led_alarm/view/home_screen/fragment/events_list/events_list_page.dart';
import 'package:led_alarm/view/home_screen/fragment/settings/settings_page.dart';
import 'package:led_alarm/view/home_screen/fragment/start/start_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _selectedIndex = 0;
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor.withAlpha(190),
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColorLight),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: <Widget>[
            StartPage(),
            EventsListPage(),
            AlarmsListPage(),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 10,
              activeColor: Theme.of(context).primaryColor,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: Duration(milliseconds: 400),
              // ignore: deprecated_member_use
              tabBackgroundColor: Theme.of(context).buttonColor.withAlpha(150),
              color: Theme.of(context).primaryColorLight,
              tabs: _buildNavigationTabs(),
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<GButton> _buildNavigationTabs() {
    return <GButton>[
      GButton(
        icon: Icons.home_outlined,
        text: AppLocalizations.of(context)!.start,
      ),
      GButton(
        icon: Icons.storage_outlined,
        text: AppLocalizations.of(context)!.lightingPlan,
      ),
      GButton(
        icon: Icons.alarm_outlined,
        text: AppLocalizations.of(context)!.alarms,
      ),
      GButton(
        icon: Icons.settings_outlined,
        text: AppLocalizations.of(context)!.settings,
      ),
    ];
  }

  Future<void> test() async{

  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
}
