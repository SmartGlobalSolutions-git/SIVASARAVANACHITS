import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class HelpSupportApiService {
  static Future<Map<String, dynamic>?> fetchHelpSupport() async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();
      final String? token = await SharedPrefsHelper.getToken();
      final int? cusId = await SharedPrefsHelper.getCusId();

      final requestBody = {
        'type': '5021',
        'cid': ApiConstants.cid.toString(),
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        if (token != null) 'token': token,
        if (cusId != null) 'cus_id': cusId.toString(),
      };

      debugPrint('--- HELP & SUPPORT API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- HELP & SUPPORT API RESPONSE ---');
      debugPrint('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['error'] == false) {
          return decoded['contact'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Help Support API Error: $e');
      return null;
    }
  }
}
