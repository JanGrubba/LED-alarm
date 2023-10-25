import 'package:led_alarm/util/common_package.dart';
import 'package:numberpicker/numberpicker.dart';

typedef OnChangedHour(int hour);
typedef OnChangedMinute(int minute);

class SpinnerTimePickerTile extends StatelessWidget {
  final Alarm alarm;
  final OnChangedHour onChangedHour;
  final OnChangedMinute onChangedMinute;

  const SpinnerTimePickerTile({
    Key? key,
    required this.alarm,
    required this.onChangedHour,
    required this.onChangedMinute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _createHourSpinner(context),
          SizedBox(width: 20),
          _createVerticalDivider(),
          SizedBox(width: 20),
          _createMinutesSpinner(context),
        ],
      ),
    );
  }

  Widget _createVerticalDivider() {
    return VerticalDivider(indent: 20, endIndent: 20, color: Colors.white38);
  }

  Widget _createHourSpinner(BuildContext context) {
    return _createSpinner(
      context: context,
      pickedValue: alarm.hour,
      maxValue: 24,
      onChanged: (value) => onChangedHour(value),
    );
  }

  Widget _createMinutesSpinner(BuildContext context) {
    return _createSpinner(
      context: context,
      pickedValue: alarm.minute,
      maxValue: 60,
      onChanged: (value) => onChangedMinute(value),
    );
  }

  Widget _createSpinner(
      {required BuildContext context,
      required int pickedValue,
      required int maxValue,
      required void Function(int) onChanged}) {
    return NumberPicker(
      value: pickedValue,
      minValue: 0,
      maxValue: maxValue,
      step: 1,
      itemHeight: 70,
      itemWidth: 70,
      axis: Axis.vertical,
      selectedTextStyle: Theme.of(context)
          .textTheme
          .headline3!
          .copyWith(color: MyTextStyle.getMatchingColorByTheme(context: context), fontWeight: FontWeight.w300),
      textStyle: TextStyle(
          color: MyTextStyle.getMatchingColorByTheme(context: context), fontSize: 28, fontWeight: FontWeight.w200),
      onChanged: onChanged,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyTextStyle.getMatchingColorByTheme(context: context).withAlpha(25),
          border: Border.all(color: Colors.white)),
    );
  }
}
