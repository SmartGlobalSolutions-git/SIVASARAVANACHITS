import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';


class OtpApiService {
  static Future<Map<String, dynamic>?> verifyOtp({
    required String mobile,
    required String otp,
    required String token,
  }) async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();

      final String appSignature = await SmsAutoFill().getAppSignature;

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5002',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'mobile': mobile,
        'otp': otp,
        'token': token,
        'app_signature': appSignature,
      };

      debugPrint('--- OTP API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- OTP API RESPONSE ---');
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
      debugPrint('OTP API Error: $e');
      return {
        'error': true,
        'error_msg': 'Exception occurred: $e'
      };
    }
  }
}
