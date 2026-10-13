import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Request permissions and retrieve FCM token
  Future<String?> getFcmToken() async {
    try {
      // 1. Request notification permissions (required for Android 13+ & iOS)
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log('Notification permission granted.');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        log('Provisional notification permission granted.');
      } else {
        log('Notification permission denied.');
      }

      // 2. Fetch FCM Token
      String? token = await _messaging.getToken();
      log('================== FCM TOKEN ==================');
      log(token ?? 'No token found');
      log('==============================================');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e');
      return null;
    }
  }

  /// Listen to token refresh
  void onTokenRefresh(void Function(String token) callback) {
    _messaging.onTokenRefresh.listen(callback);
  }
}
