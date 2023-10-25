import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageController {
  final _storage = FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    _storage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) async {
    return await _storage.read(key: key);
  }

  Future<bool> containSecureData(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}

abstract class SecureStorageKeys {
  static const String INTRO_PAGE_FLAG = "IntroPageFlag";
  static const String ADD_EVENT_INTRODUCTION_FLAG = "addEventIntroductionFlag";
  static const String HOME_PAGE_INTRODUCTION_FLAG = "homePageIntroductionFlag";
  static const String TOGGLE_INDEX_SELECTED = "toggleIndexSelected";
  static const String SELECTED_COLOR = "selectedColor";
}
