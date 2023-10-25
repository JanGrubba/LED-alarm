// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggleable_boolean.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ToggleableBoolean on _ToggleableBoolean, Store {
  final _$_valueAtom = Atom(name: '_ToggleableBoolean._value');

  @override
  bool get _value {
    _$_valueAtom.reportRead();
    return super._value;
  }

  @override
  set _value(bool value) {
    _$_valueAtom.reportWrite(value, super._value, () {
      super._value = value;
    });
  }

  final _$_ToggleableBooleanActionController =
      ActionController(name: '_ToggleableBoolean');

  @override
  void toggle() {
    final _$actionInfo = _$_ToggleableBooleanActionController.startAction(
        name: '_ToggleableBoolean.toggle');
    try {
      return super.toggle();
    } finally {
      _$_ToggleableBooleanActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTrue() {
    final _$actionInfo = _$_ToggleableBooleanActionController.startAction(
        name: '_ToggleableBoolean.setTrue');
    try {
      return super.setTrue();
    } finally {
      _$_ToggleableBooleanActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFalse() {
    final _$actionInfo = _$_ToggleableBooleanActionController.startAction(
        name: '_ToggleableBoolean.setFalse');
    try {
      return super.setFalse();
    } finally {
      _$_ToggleableBooleanActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
