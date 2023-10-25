import 'package:mobx/mobx.dart';

// klasa pomocnicza, opakowująca typ primtywny int
// przenosi stan między widgetami
// zastępuje bloc, tam gdzie ten byłby zbyt zaawansowny

part 'observable_int.g.dart';

class ObservableInt = _ObservableInt with _$ObservableInt;

abstract class _ObservableInt with Store {
  @observable
  int _value = 0;

  _ObservableInt(this._value);

  int get value => _value;

  @action
  void set(int value) {
    _value = value;
  }

}
