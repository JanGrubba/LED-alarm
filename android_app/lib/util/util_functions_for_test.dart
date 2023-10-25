import 'package:flutter_test/flutter_test.dart';
import 'package:led_alarm/main.dart';
import 'package:led_alarm/util/common_package.dart';

/// plik zawiera funckje wykorzystywane podczas testowanie
// umieszczenie go w pliku `test` powoduje błędy kompilacji

/// funkcja rozszerzająca klasę WidgetTester
/// funckja drukuje na konsoli wszystkie widgety aktualnie wyrenderowane
extension WidgetTesterExt on WidgetTester {
  void printAll() {
    this.allElements.forEach((element) {
      print(element);
    });
  }
}

/// funkcja opakowująca testowany widget - stanowi kopię funckję build z pliku main.dart
/// służy do testowania złożonych widgetów np całej strony
/// dostarcza internacjonalizację i podstawowe globalne bloki
class UtilsTesting {
  Future<Widget> makeTestableWidget({required Widget child}) async {
    return MediaQuery(
      data: MediaQueryData(),
      child: MyApp(home: child, mode: 'mock'),
    );
  }
}
