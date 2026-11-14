import 'dart:convert';

import 'package:http/http.dart' as http;

class NetWorkHelper {
  final String url;

  NetWorkHelper(this.url);

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception(
        'Weather request failed with status ${response.statusCode}.');
  }
}
