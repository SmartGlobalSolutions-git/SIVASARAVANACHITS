import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class AboutUsApiService {
  static Future<Map<String, dynamic>?> fetchAboutUs() async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5009',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
      };

      debugPrint('--- ABOUT US API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- ABOUT US API RESPONSE ---');
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
      debugPrint('About Us API Error: $e');
      return {
        'error': true,
        'error_msg': 'Exception occurred: $e'
      };
    }
  }
}
