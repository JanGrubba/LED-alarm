// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'observable_int.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ObservableInt on _ObservableInt, Store {
  final _$_valueAtom = Atom(name: '_ObservableInt._value');

  @override
  int get _value {
    _$_valueAtom.reportRead();
    return super._value;
  }

  @override
  set _value(int value) {
    _$_valueAtom.reportWrite(value, super._value, () {
      super._value = value;
    });
  }

  final _$_ObservableIntActionController =
      ActionController(name: '_ObservableInt');

  @override
  void set(int value) {
    final _$actionInfo = _$_ObservableIntActionController.startAction(
        name: '_ObservableInt.set');
    try {
      return super.set(value);
    } finally {
      _$_ObservableIntActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
