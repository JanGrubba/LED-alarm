import 'package:led_alarm/util/common_package.dart';

typedef OnChooseMode<T extends Alarm>(T alarm, AlarmRepeatMode mode);

class AlarmModeTile<T extends Alarm> extends StatelessWidget {
  final T alarm;
  final OnChooseMode<T> onChoose;

  const AlarmModeTile({Key? key, required this.alarm, required this.onChoose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color matchingColor =
        MyTextStyle.getMatchingColorByBackgroundColor(backgroundColor: Theme.of(context).primaryColor);
    return ListTile(
      leading: Text(
        AppLocalizations.of(context)!.repeat,
        style: MyTextStyle.getAppBarTextStyleWithMatchedColor(context),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            alarm.repeatMode.getTitle(context),
            style: TextStyle(
              color: matchingColor,
            ),
          ),
          SizedBox(width: 5),
          Icon(
            Icons.arrow_forward_ios,
            color: matchingColor,
          ),
        ],
      ),
      onTap: () => _showBottomMenu(context),
    );
  }

  void _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        List<AlarmRepeatMode> alarmRepeatModes = AlarmRepeatMode.values;
        return Column(
          key: Key("AlarmModeBottomMenu"),
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            alarmRepeatModes.length,
            (index) => _buildTile(context, alarmRepeatModes[index]),
          ),
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, AlarmRepeatMode mode) {
    bool isSelected = alarm.repeatMode == mode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        selected: isSelected,
        trailing: isSelected ? Icon(Icons.done) : SizedBox.shrink(),
        title: new Text(
          mode.getTitle(context),
        ),
        onTap: () => onChoose(alarm, mode),
      ),
    );
  }
}
