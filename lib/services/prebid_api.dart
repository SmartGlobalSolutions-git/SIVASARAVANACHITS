import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class PrebidApiService {
  static Future<List<dynamic>?> fetchPrebidList() async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();
      final String? token = await SharedPrefsHelper.getToken();
      final cusId = await SharedPrefsHelper.getCusId();

      final Map<String, String> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'type': '5013',
      };
      
      if (token != null) requestBody['token'] = token;
      if (cusId != null) requestBody['cus_id'] = cusId.toString();

      debugPrint('--- PREBID API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- PREBID API RESPONSE ---');
      debugPrint('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['monthly_list'] != null) {
          return decoded['monthly_list'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Prebid API Error: $e');
      return null;
    }
  }
}
