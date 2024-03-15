import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class ResponseData {
  final int statusCode;
  final dynamic responseBody;

  ResponseData(this.statusCode, this.responseBody);
}

// Future<ResponseData> sendPostRequest(
//     String url, Map<String, String> headers, Map<String, dynamic> body) async {
//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: json.encode(body),
//     );

//     // print("check search in request: ${response.body}");

//     return ResponseData(response.statusCode, utf8.decode(response.bodyBytes));

//     // if (response.statusCode == 200) {
//     //   Map<String, dynamic> jsonData = json.decode(response.body);
//     //   return jsonData;
//     // } else {
//     //   throw Exception('Error: ${response.statusCode}');
//     // }
//   } catch (e) {
//     throw Exception('Exception: $e');
//   }
// }

Future<Map<String, dynamic>> sendPostRequest(
    String url, Map<String, String> headers, Map<String, dynamic> body) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData =
          json.decode(utf8.decode(response.bodyBytes));

      return jsonData;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error in post request test:$e');
  }
}

Future<Map<String, dynamic>> sendGetRequest(
    String url, Map<String, String> headers) async {
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
      throw Exception('Error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Exception: $e');
  }
}

Future<Map<String, dynamic>> sendGetRequestWithQueryParameters(String url,
    Map<String, String> headers, Map<String, dynamic> queryParameters) async {
  try {
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: headers,
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

Future<Map<String, dynamic>> sendPatchRequest(
    String url, Map<String, String> headers, Map<String, dynamic> body) async {
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    // Handle response as needed
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

Future<Map<String, dynamic>> sendDeleteRequest(
    String url, Map<String, String> headers) async {
  try {
    final response = await http.delete(Uri.parse(url), headers: headers);

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

Future<Map<String, dynamic>> postFilesRequest(
    List<File> files, String url) async {
  print("check token return 1: ${files}");
  try {
    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Add each file to the request
    for (int i = 0; i < files.length; i++) {
      var file = files[i];
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile(
        'files', // Use a unique field name for each file
        stream,
        length,
        filename: path.basename(file.path),
        contentType: MediaType.parse(lookupMimeType(file.path) ?? 'image/jpeg'),
      );

      request.files.add(multipartFile);

      print("check token return files: ${request.files[0]}");
    }

    // Send the request
    var response = await request.send();

    print("check token return 2: ${response.statusCode}");

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonData = json.decode(responseBody);

      print("check token return 3: ${responseBody}");
      return jsonData;
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception('Exception: $e');
  }
}

Future<Map<String, dynamic>> postFileRequest(File file, String url) async {
  print("check token return profile: $file");
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
      print(file.path);
      print(jsonData);
      print("check token return outside: $responseBody");
      return jsonData;
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception('Exception: $e');
  }
}
