
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  //
  // static const String taiKhoan = 'taiKhoan';
  static const String fullNm = 'fullNm';
  // static const String email = 'email';
  static const String cityFilter = 'cityFilter';
 // static const String password = 'password';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }
  Future<void> saveCheckbox(String cityFilter) async =>
      await _preferences.setString(SharedPrefKeys.cityFilter, cityFilter);

  // Get username
  String get getCityFilter =>
      _preferences.getString(SharedPrefKeys.cityFilter) ?? '';

  // Save userName
  Future<void> saveUserNm(String userNm) async =>
      await _preferences.setString(SharedPrefKeys.fullNm, userNm);

  // Remove User name when logout
  Future<void> removeUserNm() async =>
      await _preferences.remove(SharedPrefKeys.fullNm);


}
