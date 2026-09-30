import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyLat = 'latitude';
  static const String _keyLng = 'longitude';
  static const String _keyDeviceId = 'device_id';

  // Save location
  static Future<void> saveLocation(String lat, String lng) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLat, lat);
    await prefs.setString(_keyLng, lng);
  }

  // Get Latitude
  static Future<String> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLat) ?? '123'; // Default fallback
  }

  // Get Longitude
  static Future<String> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLng) ?? '123'; // Default fallback
  }

  // Save Device ID
  static Future<void> saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeviceId, deviceId);
  }

  // Get Device ID
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDeviceId) ?? 'unknown_device';
  }

  // Save Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Save Cus ID
  static Future<void> saveCusId(int cusId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cus_id', cusId);
  }

  // Get Cus ID
  static Future<int?> getCusId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cus_id');
  }

  // Save Is New User
  static Future<void> saveIsNewUser(bool isNewUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_new_user', isNewUser);
  }

  // Get Is New User
  static Future<bool> getIsNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_new_user') ?? false;
  }

  // Clear Preferences on Logout
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('cus_id');
    await prefs.remove('is_new_user');
  }
}
