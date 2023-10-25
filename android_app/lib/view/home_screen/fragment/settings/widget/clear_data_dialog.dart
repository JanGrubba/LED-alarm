import 'package:led_alarm/controller/secure_storage_controller.dart';
import 'package:led_alarm/util/common_package.dart';
import 'package:led_alarm/util/widget/accept_button.dart';
import 'package:led_alarm/util/widget/cancel_button.dart';

class ClearDataDialog extends StatefulWidget {
  const ClearDataDialog({Key? key}) : super(key: key);

  @override
  _ClearDataDialogState createState() => _ClearDataDialogState();
}

class _ClearDataDialogState extends State<ClearDataDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: const Text('Are you sure you want to clear data?', textAlign: TextAlign.center),
      actions: <Widget>[
        Column(
          children: [
            _generateSubTitle(),
            _generateDialogActionButtons(context),
          ],
        )
      ],
    );
  }

  Widget _generateSubTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text('Wyczyszczenie danych spowoduje usunięcie wszystkich zapisanych alarmów, akcji.'),
    );
  }

  Widget _generateDialogActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        CancelButton(),
        AcceptButton(onPressed: () {
          final SecureStorageController _secureStorageController = locator.get<SecureStorageController>();
          _secureStorageController.deleteAllSecureData();
          Navigator.pop(context, 'OK');
        })
      ]),
    );
  }
}
