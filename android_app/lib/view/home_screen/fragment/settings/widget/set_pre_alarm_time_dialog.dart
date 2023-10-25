import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/widget/accept_button.dart';
import 'package:led_alarm/util/widget/cancel_button.dart';
import 'package:numberpicker/numberpicker.dart';

class SetPreAlarmTime extends StatefulWidget {
  const SetPreAlarmTime({Key? key}) : super(key: key);

  @override
  _SetPreAlarmTimeState createState() => _SetPreAlarmTimeState();
}

class _SetPreAlarmTimeState extends State<SetPreAlarmTime> {
  int _currentHorizontalIntValue = 10;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text('Set time'),
      actions: <Widget>[
        Column(
          children: [
            _getTimePicker(context),
            _generateDialogActionButtons(context),
          ],
        )
      ],
    );
  }

  Widget _getTimePicker(BuildContext context) {
    return Column(
      children: <Widget>[
        // Text('Horizontal', style: Theme.of(context).textTheme.headline6),
        NumberPicker(
          value: _currentHorizontalIntValue,
          minValue: 0,
          maxValue: 20,
          step: 1,
          itemHeight: 65,
          itemWidth: 65,
          axis: Axis.horizontal,
          onChanged: (value) => setState(() => _currentHorizontalIntValue = value),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // shape: BoxShape.circle,
            color: Theme.of(context).primaryColor.withAlpha(20),
            border: Border.all(color: Theme.of(context).primaryColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                _currentHorizontalIntValue = (_currentHorizontalIntValue - 1).clamp(0, 20);
              }),
            ),
            Text('Current  value: $_currentHorizontalIntValue'),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                _currentHorizontalIntValue = (_currentHorizontalIntValue + 1).clamp(0, 20);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _generateDialogActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [CancelButton(), AcceptButton(onPressed: () {})]),
    );
  }
}
