import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'shared_prefs_helper.dart';

class ChitSchemeApiService {
  static Future<Map<String, String>> _getBaseRequestData() async {
    final String lt = await SharedPrefsHelper.getLatitude();
    final String ln = await SharedPrefsHelper.getLongitude();
    final String deviceId = await SharedPrefsHelper.getDeviceId();
    final String? token = await SharedPrefsHelper.getToken();

    return {
      'cid': ApiConstants.cid.toString(),
      'lt': lt,
      'ln': ln,
      'device_id': deviceId,
      if (token != null) 'token': token,
    };
  }

  // 5003 - Chit Schemes List
  static Future<List<dynamic>?> fetchChitSchemes() async {
    try {
      final requestBody = await _getBaseRequestData();
      requestBody['type'] = '5003';

      debugPrint('--- CHIT SCHEMES API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      print('--- CHIT SCHEMES API RESPONSE ---');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded;
        } else if (decoded is Map && decoded['data'] != null) {
           return decoded['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Chit Schemes API Error: $e');
      return null;
    }
  }

  // 5003 (with ID) - Chit Scheme Detail
  static Future<Map<String, dynamic>?> fetchChitSchemeDetail(int id) async {
    try {
      final requestBody = await _getBaseRequestData();
      requestBody['type'] = '5003';
      requestBody['id'] = id.toString();

      debugPrint('--- CHIT SCHEME DETAIL API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      print('--- CHIT SCHEME DETAIL API RESPONSE ---');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Chit Scheme Detail API Error: $e');
      return null;
    }
  }

  // 5008 - Available Chits
  static Future<List<dynamic>?> fetchAvailableChits() async {
    try {
      final requestBody = await _getBaseRequestData();
      requestBody['type'] = '5008';

      debugPrint('--- AVAILABLE CHITS API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      print('--- AVAILABLE CHITS API RESPONSE ---');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['error'] == false) {
          return decoded['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Available Chits API Error: $e');
      return null;
    }
  }
  // 5004 - My Chits
  static Future<List<dynamic>?> fetchMyChits() async {
    try {
      final requestBody = await _getBaseRequestData();
      final cusId = await SharedPrefsHelper.getCusId();
      requestBody['type'] = '5004';
      if (cusId != null) requestBody['cus_id'] = cusId.toString();

      debugPrint('--- MY CHITS API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      debugPrint('--- MY CHITS API RESPONSE ---');
      debugPrint('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['monthly_list'] != null) {
          return decoded['monthly_list'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('My Chits API Error: $e');
      return null;
    }
  }

  // 5005 - Chit Statement
  static Future<Map<String, dynamic>?> fetchChitStatement(int chitId) async {
    try {
      final requestBody = await _getBaseRequestData();
      final cusId = await SharedPrefsHelper.getCusId();
      requestBody['type'] = '5005';
      requestBody['chit_id'] = chitId.toString();
      if (cusId != null) requestBody['cus_id'] = cusId.toString();

      debugPrint('--- CHIT STATEMENT API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      print('--- CHIT STATEMENT API RESPONSE ---');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['status'] == true && decoded['data'] != null) {
          return decoded['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Chit Statement API Error: $e');
      return null;
    }
  }

  // 5012 - Passbook Statement
  static Future<Map<String, dynamic>?> fetchPassbookStatement(int chitId) async {
    try {
      final requestBody = await _getBaseRequestData();
      final cusId = await SharedPrefsHelper.getCusId();
      requestBody['type'] = '5012';
      requestBody['chit_id'] = chitId.toString();
      if (cusId != null) requestBody['cus_id'] = cusId.toString();

      debugPrint('--- PASSBOOK STATEMENT API REQUEST ---');
      debugPrint('BODY: $requestBody');

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: requestBody,
      );

      print('--- PASSBOOK STATEMENT API RESPONSE ---');
      print('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['status'] == true && decoded['data'] != null) {
          return decoded['data'];
        }
      }
      return null;
    } catch (e) {
      debugPrint('Passbook Statement API Error: $e');
      return null;
    }
  }
}
