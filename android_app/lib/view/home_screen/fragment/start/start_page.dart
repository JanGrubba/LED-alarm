import 'package:flutter_intro/flutter_intro.dart';
import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/service/firebase_communication_service.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/observable_int.dart';
import 'package:led_alarm/view/home_screen/fragment/start/widget/action_select_card.dart';
import 'package:led_alarm/view/home_screen/fragment/start/widget/color_info_select_card.dart';
import 'package:led_alarm/view/home_screen/fragment/start/widget/state_card.dart';
import 'package:alan_voice/alan_voice.dart';

class StartPage extends StatefulWidget {
  final ToggleableBoolean isColorCardVisible = ToggleableBoolean(true);
  final ToggleableBoolean isAutoMode = ToggleableBoolean(false);

  StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Intro? homePageIntro;
  final FirebaseCommunicationService _firebaseCommunicationService = locator.get<FirebaseCommunicationService>();
  final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
  late ObservableInt toggleIndexSelected;

  _StartPageState(){
    AlanVoice.addButton(
        "c64049bade97df0332733ac663c23e142e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    );
    AlanVoice.callbacks.add((command)=> _processResponse(command.data));
  }

  _processResponse(Map<String, dynamic> response) async {

    switch(response["command"]){
      case "turn_on_plain":
        _firebaseCommunicationService.changeDeviceWorkingMode(1);
        break;
      case "turn_on_auto":
        _firebaseCommunicationService.changeDeviceWorkingMode(2);
        break;
      case "turn_off":
        _firebaseCommunicationService.changeDeviceWorkingMode(0);
        break;
    }
  }

  @override
  void initState(){
    _startIntroductionIfFirstTime();
    test().then((value) {
      if(value != -1) {
        toggleIndexSelected = ObservableInt(value);
        setState(() {});
      }
    } );
    toggleIndexSelected = ObservableInt(1);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initToggleIndexSelected();
    });
    super.initState();
  }

  Future<int> test() async {
    String? index = await _secureStorageController.readSecureData(SecureStorageKeys.TOGGLE_INDEX_SELECTED);
    int x = -1;
    if(index == null) {
      x = (await _firebaseCommunicationService.isDeviceWorking());
    }
    else{
      x = int.parse(index);
    }
    return x;
  }

  Future<void> _initToggleIndexSelected() async {
    String? index = await _secureStorageController.readSecureData(SecureStorageKeys.TOGGLE_INDEX_SELECTED);
    if(index != null) {
      toggleIndexSelected = ObservableInt(int.parse(index));
    }
  }

  void _initIntroduction() {
    homePageIntro = Intro(
      stepCount: 7,
      maskClosable: true,
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Witaj w krótkim samouczku',
          'W tym miejscu wyświetlane są informacje o rzeczywistym stanie oświetlenia dane pobierane są z serwera',
          'Napis oraz ikona wskazuje w jakim stanie jest aktulanie oświetlenie',
          'A kolor znacznika odzwierciedla aktualnie wyświetlany kolor oświetlenia',
          'W tym miejscu możesz ręcznie zmienić stan oświetlenia',
          "Masz do wyboru 3 stany: \n• Wyłącz oświetlenie \n• Włącz oświetlenie \n• Auto - które pozwala oświetleniu działać wg ustawionego planu",
          'W tym miejscu możesz ręcznie zmienić kolor oświetlenia',
        ],
        buttonTextBuilder: (currPage, totalPage) {
          return currPage < totalPage - 1 ? AppLocalizations.of(context)!.next : AppLocalizations.of(context)!.finish;
        },
      ),
    );
  }

  void _startIntroductionIfFirstTime() {
    _initIntroduction();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) async {
        final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
        bool isExecuted =
            await _secureStorageController.containSecureData(SecureStorageKeys.HOME_PAGE_INTRODUCTION_FLAG);
        if (!isExecuted) {
          homePageIntro!.start(context);
          _secureStorageController.writeSecureData(SecureStorageKeys.HOME_PAGE_INTRODUCTION_FLAG, "executed");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Theme.of(context).primaryColor.withAlpha(185), Theme.of(context).primaryColor],
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          key: homePageIntro?.keys[0],
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
            child: Column(
              children: [
                _createLogo(),
                StateCard(
                    key: homePageIntro?.keys[1],
                    homePageIntro: homePageIntro,
                    toggleIndexSelected: toggleIndexSelected),
                ActionSelectCard(
                  key: homePageIntro?.keys[4],
                  homePageIntro: homePageIntro,
                  toggleIndexSelected: toggleIndexSelected,
                ),
                ColorInfoSelectCard(
                  toggleIndexSelected: toggleIndexSelected,
                  homePageIntro: homePageIntro,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          height: 80,
          width: 80,
          child: Image.asset("assets/images/lightbulb_gif_loop.gif"),
        ),
      ),
    );
  }
}
