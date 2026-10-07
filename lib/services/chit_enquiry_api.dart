import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class ChitEnquiryApi {
  static Future<Map<String, dynamic>> submitEnquiry({
    required String name,
    required String mobile,
    required String email,
    required String remarks,
  }) async {
    try {
      final String lt = await SharedPrefsHelper.getLatitude();
      final String ln = await SharedPrefsHelper.getLongitude();
      final String deviceId = await SharedPrefsHelper.getDeviceId();

      final Map<String, dynamic> requestBody = {
        'cid': ApiConstants.cid.toString(),
        'type': '5022',
        'lt': lt,
        'ln': ln,
        'device_id': deviceId,
        'name': name,
        'mobile': mobile,
        'remarks': remarks,
        'email': email,
      };

      debugPrint('--- CHIT ENQUIRY API REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- CHIT ENQUIRY API RESPONSE ---');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Failed with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      debugPrint('Chit Enquiry API Error: $e');
      return {
        'status': 'error',
        'message': 'Exception occurred: $e'
      };
    }
  }
}
