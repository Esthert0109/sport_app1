import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Constants/apiConstant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CommonServices {
  final String baseUrl = ApiConstants.baseUrl;

  Map<String, String> headers = {
    "Content-Type": "application/json; charset=utf-8",
    "accept": "application/json"
  };

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      print(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));

        return jsonData;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> postRequestWithoutBody(String url) async {
    try {
      final response = await http.post(Uri.parse(url), headers: headers);

      print(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonData;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonData;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> postFileRequest(File file, String url) async {
    try {
      // 创建一个MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: path.basename(file.path), // Use path.basename
        contentType: MediaType.parse(lookupMimeType(file.path) ?? 'image/jpeg'),
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonData = json.decode(responseBody);
        return jsonData;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> patchRequest(
      String url, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //'Cookie': 'token=3287071134634f8eba5992bcc96a30d3',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> deleteRequest(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token") ?? '';
    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8",
      "token": token,
      "accept": "application/json"
    };

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> postRequestWithToken(
      String url, Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8",
      "token": token,
      "accept": "application/json"
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> getRequestWithToken(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=utf-8",
      "token": token,
      "accept": "application/json"
    };

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData =
            json.decode(utf8.decode(response.bodyBytes));
        return jsonData;
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Exception: $e');
    }
  }
}
