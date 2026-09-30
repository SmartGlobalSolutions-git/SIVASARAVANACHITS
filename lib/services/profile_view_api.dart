import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class ProfileViewApiService {
  static Future<Map<String, dynamic>?> fetchProfile() async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();
      final int? cusId = await SharedPrefsHelper.getCusId();
      final String? token = await SharedPrefsHelper.getToken();

      if (cusId == null || token == null) {
        debugPrint('Missing cusId or token');
        return {
          'error': true,
          'error_msg': 'Authentication missing. Please login again.'
        };
      }

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5006',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'cus_id': cusId.toString(),
        'token': token,
      };

      debugPrint('--- PROFILE VIEW API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- PROFILE VIEW API RESPONSE ---');
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
      debugPrint('Profile View API Error: $e');
      return {
        'error': true,
        'error_msg': 'Exception occurred: $e'
      };
    }
  }
}
