import 'package:led_alarm/bloc/theme/theme_bloc.dart';
import 'package:led_alarm/style/app_theme.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/widget/cancel_button.dart';

class ChooseColorDialog extends StatelessWidget {
  const ChooseColorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose theme'),
      actions: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(children: _getContent(context), alignment: WrapAlignment.start),
        )
      ],
    );
  }

  List<Widget> _getContent(BuildContext context) {
    List<Widget> list = _generateButtonsFromThemes(context);
    list.add(_generateDialogActionButtons(context));
    return list;
  }

  List<Widget> _generateButtonsFromThemes(BuildContext context) {
    return List.generate(
      AppTheme.values.length,
      (index) => RawMaterialButton(
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
        onPressed: () {
          BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.values[index]));
          Navigator.pop(context, 'OK');
        },
        elevation: 1.0,
        fillColor: appThemeData[AppTheme.values[index]]!.primaryColor,
        shape: CircleBorder(),
      ),
    );
  }

  Widget _generateDialogActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end, children: [CancelButton()]),
    );
  }

}
