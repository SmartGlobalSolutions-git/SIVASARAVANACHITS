import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class TermsAndConditionsApiService {
  static Future<Map<String, dynamic>?> fetchTermsAndConditions() async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();
      final String token = await SharedPrefsHelper.getToken() ?? '';
      final int cusId = await SharedPrefsHelper.getCusId() ?? 0;

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5020',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'token': token,
        'cus_id': cusId.toString(),
      };

      debugPrint('--- TERMS AND CONDITIONS API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- TERMS AND CONDITIONS API RESPONSE ---');
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
      debugPrint('Terms and Conditions API Error: $e');
      return {
        'error': true,
        'error_msg': 'Exception occurred: $e'
      };
    }
  }
}
