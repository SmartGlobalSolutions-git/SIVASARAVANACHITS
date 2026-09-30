import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginApiService {
  static Future<Map<String, dynamic>?> login(String mobile) async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();
      final String appSignature = await SmsAutoFill().getAppSignature;

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5001',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'mobile': mobile,
        'app_signature': appSignature,
      };

      debugPrint('--- LOGIN API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody, // Sending as form-data / url-encoded usually if it's like this, or json. We will send as form data first. If it's json, we should jsonEncode.
      );

      debugPrint('--- LOGIN API RESPONSE ---');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': true,
          'error_msg': 'Failed with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      debugPrint('Login API Error: $e');
      return {
        'error': true,
        'error_msg': 'Exception occurred: $e'
      };
    }
  }
}
