import 'package:led_alarm/util/common_package.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

typedef OnChange(Map<DayOfWeek, bool> listDays);

class WeekButtonsTile extends StatelessWidget {
  final OnChange onChange;
  final AlarmRepeatMode initMode;
  final Map<DayOfWeek, bool> listDays;

  WeekButtonsTile({Key? key, required this.onChange, required this.initMode, required this.listDays}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return  Conditional.single(
      context: context,
      conditionBuilder: (BuildContext context) =>initMode != AlarmRepeatMode.Once,
      widgetBuilder: (BuildContext context) => _buildRowButtons(context, listDays),
      fallbackBuilder: (BuildContext context) => SizedBox.shrink(),
    );
  }

  Widget _buildRowButtons(BuildContext context, Map<DayOfWeek, bool> listDays) {
    List<DayOfWeek> days = DayOfWeek.values;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        days.length,
        (index) => _createWeekButton(
          context: context,
          listDays: listDays,
          day: days[index],
          title: days[index].getName(context),
        ),
      ),
    );
  }

  Widget _createWeekButton(
      {required BuildContext context, required Map<DayOfWeek, bool> listDays, required DayOfWeek day, required String title}) {
    final bool buttonState = listDays[day]!;
    return ElevatedButton(
      key: Key(title + buttonState.toString()),
      onPressed: () {
        Map<DayOfWeek, bool> newListDays = Map.from(listDays);
        bool dayState = newListDays[day]!;
        dayState ^= true;
        newListDays[day] = dayState;
        onChange.call(newListDays);
      },
      child: Text(
        title,
        style: TextStyle(
            color: buttonState
                ? MyTextStyle.getMatchingColorByTheme(context: context, darkColor: Colors.black54)
                : Colors.black54),
      ),
      style: ButtonStyle(
        visualDensity: VisualDensity(horizontal: -4),
        shape: MaterialStateProperty.all(CircleBorder()),
        elevation: MaterialStateProperty.all(5),
        padding: MaterialStateProperty.all(EdgeInsets.all(12)),
        backgroundColor: MaterialStateProperty.all(buttonState ? Theme.of(context).primaryColor : Colors.white),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed))
              return buttonState ? Colors.white : Theme.of(context).primaryColor;
          },
        ),
      ),
    );
  }
}
