import 'package:mobx/mobx.dart';

// klasa pomocnicza, opakowująca typ primtywny bool
// przenosi stan między widgetami
// zastępuje bloc, tam gdzie ten byłby zbyt zaawansowny

part 'toggleable_boolean.g.dart';

class ToggleableBoolean = _ToggleableBoolean with _$ToggleableBoolean;

abstract class _ToggleableBoolean with Store {
  @observable
  bool _value = false;

  _ToggleableBoolean(this._value);

  bool get value => _value;

  @action
  void toggle() {
    _value ^= true;
  }

  @action
  void setTrue() {
    _value = true;
  }

  @action
  void setFalse() {
    _value = false;
  }
}
