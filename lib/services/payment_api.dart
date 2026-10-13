import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class PaymentApiService {
  static Future<Map<String, String>> _getBaseRequestData() async {
    final String lt = await SharedPrefsHelper.getLatitude();
    final String ln = await SharedPrefsHelper.getLongitude();
    final String deviceId = await SharedPrefsHelper.getDeviceId();
    final String? token = await SharedPrefsHelper.getToken();

    final Map<String, String> data = {
      'cid': ApiConstants.cid.toString(),
      'lt': lt,
      'ln': ln,
      'device_id': deviceId,
    };
    if (token != null) {
      data['token'] = token;
    }
    return data;
  }

  // 5024 - Payment History
  static Future<Map<String, dynamic>?> fetchPaymentHistory({int? customerId}) async {
    try {
      final requestBody = await _getBaseRequestData();
      final cusId = customerId ?? await SharedPrefsHelper.getCusId();
      requestBody['type'] = '5024';
      if (cusId != null) {
        requestBody['cus_id'] = cusId.toString();
      }

      debugPrint('--- PAYMENT HISTORY API (5024) REQUEST ---');
      debugPrint('URL: ${ApiConstants.baseUrl}');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- PAYMENT HISTORY API (5024) RESPONSE ---');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Payment History API Error: $e');
      return null;
    }
  }
}
